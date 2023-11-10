# frozen_string_literal: true

class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!
  before_action :set_event,
                only: %i[edit update show destroy invite cancel_invitation attend reject_invite accept_invite]

  def index
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
    # respond_to do |format|
    #   format.html
    #   format.turbo_stream { render turbo_stream: turbo_stream.replace('page_content', template: 'events/index') }
    # end
  end

  def show
    if @event.nil?
      redirect_to events_path, notice: 'Event is removed by its creator!!'
    else
      @unattending_users = unattending_users
      @attend = attending
    end

    mark_current_user_event_notifications_as_read
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      respond_to do |format|
        format.html { redirect_to event_path(@event) }
        format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
      end
    else
      render :new
    end
  end

  def attend
    attendance_decider
  end

  def invite
    user_ids = params[:user_ids]
    user_ids.each do |user_id|
      attendance = Attendance.find_by(attendee_id: user_id, event_id: @event.id)
      if attendance.present?
        attendance.update(status: :pending, invited_user: true)
      else
        attendance = Attendance.create!(event_id: @event.id, host_id: current_user.id, attendee_id: user_id,
                                        status: :pending, invited_user: true)
      end
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.attendee, @event.id)
    end
    
  end

  def cancel_invitation
    attendance = Attendance.find_by(id: params[:attendance_id])
    if attendance
      attendance.update(status: :canceled, invited_user: false)
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.attendee, @event.id)
    else
      flash[:error] = 'Invitation has already been canceled.'
    end
  end

  def accept_invite
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      accept_invite_with_attend_record(user_attend)
      Attendance.notify_recipient(user_attend.status, @event, @event.creator, current_user, @event.id)
    else
      flash[:error] = "We apologize but we didn't find you in the invited list."
    end
  end

  def reject_invite
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      reject_invite_with_attend_record(user_attend)
      Attendance.notify_recipient(user_attend.status, @event, @event.creator, current_user, @event.id)
    else
      flash[:error] = 'We apologize but we didnt find you in the list.'
    end
  end

  # Event edit view
  def edit; end

  # Event edit post
  def update
    if @event.update(event_params)
      respond_to do |format|
        format.html { redirect_to event_path(@event) }
        format.turbo_stream do
          redirect_to event_path(@event, format: :turbo_stream), notice: 'Event updated successfully.'
        end
      end
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.turbo_stream { redirect_to events_path(format: :turbo_stream), notice: 'Event was destroyed successfully'  }
    end
  end

  private

  def set_event
    @event = Event.find_by(id: params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :location, :date, :public)
  end
end

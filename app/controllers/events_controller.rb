# frozen_string_literal: true

## Controls events and its attendance (attend, invite)
class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!
  before_action :set_event,
                only: %i[edit update show destroy invite cancel_invitation attend reject_invite accept_invite]

  def index
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
  end

  def show
    if @event.nil?
      flash.now[:error] = 'Event is removed by its creator!!'
      redirect_to events_path
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
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('page_content', template: 'events/show')
        end
      end
    else
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('page_content', template: 'events/new')
        end
      end
    end
  end

  def attend
    attendance_decider
  end

  def invite
    user_ids = params[:user_ids]
    return if user_ids.nil?

    user_ids.each do |_user_id|
      attendance = manipulate_attendance_record
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.attendee, @event.id)
    end
  end

  def cancel_invitation
    attendance = Attendance.find_by(id: params[:attendance_id])
    if attendance
      attendance.update(status: :canceled, invited_user: false)
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.attendee, @event.id)
    else
      flash.now[:error] = 'Invitation has already been canceled.'
    end
  end

  def accept_invite
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      accept_invite_with_attend_record(user_attend)
      Attendance.notify_recipient(user_attend.status, @event, @event.creator, current_user, @event.id)
    else
      flash.now[:error] = "We apologize but we didn't find you in the invited list."
    end
  end

  def reject_invite
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      reject_invite_with_attend_record(user_attend)
      Attendance.notify_recipient(user_attend.status, @event, @event.creator, current_user, @event.id)
    else
      flash.now[:error] = 'We apologize but we didnt find you in the list.'
    end
  end

  # Event edit view
  def edit; end

  # Event edit post
  def update
    if @event.update(event_params)
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('page_content', template: 'events/show')
        end
      end
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
    respond_to do |format|
      format.html
      format.turbo_stream do
        redirect_to events_path
      end
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

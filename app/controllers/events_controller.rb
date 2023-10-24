class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!
  before_action :set_event, only: %i[edit update show destroy invite cancel_invitation attend reject_invite accept_invite]
  
  def index
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('page_content', template: 'events/index')}
    end
  end

  def show
    if @event.nil?
      redirect_to events_path, notice: 'Event is removed by its creator!!'
    else
      attending_users = @event.attendees.where('status >= ?', 0) + [@event.creator]
      attending_ids = attending_users.pluck(:id)
      @unattending_users = User.where.not(id: attending_ids)
      @attend = current_user.attendances.find_by(event_id: @event.id)
    end
    mark_current_user_event_notifications_as_read

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('page_content', template: 'events/show')}
    end
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
    user_event = current_user.attended_events.where(id: @event.id)
    attendance = nil
    unless !user_event.present?
      attendance = Attendance.find_by(event_id: @event.id, user_id: current_user.id)
      if attendance.status != 'accepted'
        attendance.update(status: 'accepted')
        Attendance.notify_recipient('attend', @event, @event.creator, current_user, @event.id)
      else
        Attendance.notify_recipient('cancel_attend', @event, @event.creator, current_user, @event.id)
        current_user.attended_events.delete(@event)
      end
    else
      attendance = Attendance.new(event_id: @event.id, user_id: current_user.id, status: :accepted, invited_user: false, event: @event)
      attendance.save
      Attendance.notify_recipient('attend', @event, @event.creator, current_user, @event.id)
    end
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
    end
  end

  def invite
    user_ids = params[:user_ids]
    user_ids.each do |user_id|
      attendance = Attendance.find_by(user_id: user_id, event_id: @event.id)
      if attendance.present?
        attendance.update(status: :pending, invited_user: true)
      else
       attendance = Attendance.create!(event_id: @event.id, user_id: user_id, status: :pending, invited_user: true)
      end
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.user, @event.id)
    end
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
    end
  end

  def cancel_invitation
    attendance = Attendance.find_by(id: params[:attendance_id])
    if attendance
      attendance.update(status: :canceled, invited_user: false)
      Attendance.notify_recipient(attendance.status, @event, @event.creator, attendance.user, @event.id)
    else
      flash[:error] = "Invitation has already been canceled."
    end
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
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
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
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
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream) }
    end
  end

  # Event edit view
  def edit
  end

  # Event edit post
  def update
    if @event.update(event_params)
    respond_to do |format|
      format.html { redirect_to event_path(@event) }
      format.turbo_stream { redirect_to event_path(@event, format: :turbo_stream), notice: 'Event updated successfully.' }
    end
    else
      render :edit
    end
  end

  def destroy
    @event.destroy
      respond_to do |format|
      format.html { redirect_to events_path }
      format.turbo_stream { redirect_to events_path(format: :turbo_stream) }
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

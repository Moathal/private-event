class EventsController < ApplicationController
  include EventsHelper
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
  end

  def show
    @event = Event.find(params[:id])
    attending_users = @event.attendees.where('status >= ?', 0) + [@event.creator]
    attending_users.each {|user| puts "ATTENDEE>>>>>>>>>> #{user.fullname}"}
    attending_ids = attending_users.pluck(:id)
    @unattending_users = User.where.not(id: attending_ids)
    @attend = current_user.attendances.find_by(event_id: @event.id)
    puts "Attend value from show sontroller of event #{@attend}"
  end

  def new
    @event = current_user.events.build
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was created successfully'
    else
      render :new
    end
  end

  def attend
    @event = Event.find(params[:id])
    user_event = current_user.attended_events.where(id: @event.id)
    attendance = nil
    if user_event.present?
      attendance = Attendance.find_by(event_id: @event.id, user_id: current_user.id)
      if attendance.status != 'accepted'
        attendance.update(status: 'accepted')
        Attendance.notify_recipient('None', 'cancel_attend', @event, @event.creator, current_user)
      else
        Attendance.notify_recipient('None', 'cancel_attend', @event, @event.creator, current_user)
        current_user.attended_events.delete(@event)
      end
    else
      attendance = Attendance.new(event_id: @event.id, user_id: current_user.id, status: :accepted, invited_user: false, event: @event)
      attendance.save
      Attendance.notify_recipient(attendance.id, 'attend', @event, @event.creator, current_user)
    end
    redirect_to @event
  end

  def invite
    event = Event.find(params[:event_id])
    user_ids = params[:user_ids]
    user_ids.each do |user_id|
      attendance = Attendance.where(user_id: user_id, event_id: event.id)
      if attendance.present?
        attendance.update(status: :pending, invited_user: true)
      else
       attendance = Attendance.create(event_id: event.id, user_id: user_id, status: :pending, invited_user: true)
      end
      Attendance.notify_recipient(attendance.id, attendance.status, @event, @event.creator, current_user)
    end
    redirect_to event, notice: 'Invitations sent successfully.'
  end

  def cancel_invitation
    @event = Event.find(params[:id])
    attendance = Attendance.find(params[:attendance_id])
    if attendance
      attendance.update(status: :canceled, invited_user: false)
      Attendance.notify_recipient(attendance.id, attendance.status, @event, @event.creator, current_user)
    else
      flash[:error] = "Invitation has already been canceled."
    end
    redirect_to @event
  end

  def accept_invite
    @event = Event.find(params[:id])
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      accept_invite_with_attend_record(user_attend)
      user_attend.notify_recipient(user_attend.id, user_attend.status, @event, @event.creator, current_user)
    else
      flash[:error] = 'We apologize but we didnt find you in the list.'
    end
  end

  def reject_invite
    @event = Event.find(params[:id])
    user_attend = current_user.attendances.find_by(event_id: @event.id)
    if user_attend.present?
      reject_invite_with_attend_record(user_attend)
      user_attend.notify_recipient(user_attend.id, user_attend.status, @event, @event.creator, current_user)
    else
      flash[:error] = 'We apologize but we didnt find you in the list.'
    end
    redirect_to @event
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: 'Event updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Event is deleted successfully.'
  end

  private

  def event_params
    params.require(:event).permit(:location, :date, :public)
  end
end

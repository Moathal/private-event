class EventsController < ApplicationController
  include EventsHelper

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @events = Event.all.where(public: true).or(Event.where(creator: current_user))
    @user_events = current_user.events.all.where(creator: current_user) if current_user
  end

  def show
    @event = Event.find(params[:id])
    @users = EventsHelper.get_unattending_users(@event)
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
    if current_user.attended_events.include?(@event) 
      @attendance = Attendance.find_by(user_id: current_user.id, event_id: @event.id)
      @attendance.update(status: :accepted)
    else
      current_user.attendances.create(event: @event, status: :accepted, user: current_user)
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
        Attendance.create(event_id: event.id, user_id: user_id, status: :pending, invited_user: true)
      end
    end
    redirect_to event, notice: 'Invitations sent successfully.'
  end

  def cancel_invitation
    @event = Event.find(params[:id])
    attendance = Attendance.find(params[:attendance_id])
    if attendance
      attendance.update(status: :canceled, invited_user: false)
      # Send notification to the invited user here
      redirect_to @event
    else
      flash[:error] = "Invitation has already been canceled."
      redirect_to @event
    end
  end

  def accept_invite
    @event = Event.find_by(params[:id])
    user_attend = current_user.attendances.find_by(@event.id)
    if !user_attend.nil?
      case !user_attend.status.to_sym
        when :cancelled
          flash[:error] = "Invitation has been canceled."
          redirect_to @event
        when :pending
          user_attend.update(status: :accepted, invited_user: true)
          user_attend.save
      end
    else
      flash[:error] = "We apologize for the inconvinience either event was canceled or you were not invited"
      redirect_to @event
    end
  end

  def reject_invite
    @event = Event.find_by(params[:id])
    user_attend = current_user.attendances.find_by(@event.id)
    if !user_attend.nil?
      case !user_attend.status.to_sym
        when :cancelled
          flash[:error] = "Invitation has been canceled."
          redirect_to @event
        when :pending
          user_attend.update(status: :rejected, invited_user: true)
          user_attend.save
      end
    else
      flash[:error] = "We apologize for the inconvinience either event was canceled or you were not invited"
      redirect_to @event
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Event is deleted successfully."
  end

  private

  def event_params
    params.require(:event).permit(:location, :date, :public)
  end
end

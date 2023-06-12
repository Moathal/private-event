class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @events = Event.where(public: true ).or(Event.where(creator: current_user))
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = current_user.events.build
  end

  
  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to @event, notice: 'Event was created succefully'
    else
      render :new
    end
  end
  
  def attend
    @event = Event.find(params[:id])
    current_user.attended_events << @event
    redirect_to @event
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

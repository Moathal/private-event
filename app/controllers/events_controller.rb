class EventsController < ApplicationController
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

  def event_params
    params.require(:event).permit(:location, :date, :public)
  end
end

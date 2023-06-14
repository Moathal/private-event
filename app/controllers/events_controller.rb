class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @events = Event.all.where(public:true).or(Event.where(creator: current_user))
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
    
    if current_user.attended_events.include?(@event) 
      case @event.status.to_sym
      when :accepted
        @event.update(status: :rejected)
      when :rejected, :pending
        @event.update(status: :accepted)
      end
    else
      current_user.attendances.create(event: @event, status: :accepted)
    end
    respond_to do |format|
      format.html { redirect_to @event }
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("event_attendances", partial: "events/attendances", locals: { event: @event })
      end
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

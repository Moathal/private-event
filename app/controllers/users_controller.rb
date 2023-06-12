class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @past_attending_events = @user.attended_events.event.where("date < ?", Date.today)
    @future_attending_events = @user.attended_events.event.where("date >= ?", Date.today)
  end
end

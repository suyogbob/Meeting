class WelcomeController < ApplicationController
  def index
    @meeting = Meeting.new
    return unless logged_in?
    @meetings = Meeting.where(user: current_user.friends).or(Meeting.where(user: current_user)).order(created_at: :desc)
  end
end

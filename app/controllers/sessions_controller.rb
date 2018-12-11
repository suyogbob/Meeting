class SessionsController < ApplicationController
  @service

  def new
    @user = User.new
  end

  def create
    @user = User.where(email: params[:email]).first
    if !@user.nil? && @user.password == params[:password]
      session[:user_id] = @user.id
      if session[:authorization] == nil
        redirect_to '/redirect'
      else
        # redirect
        redirect_to '/'
      end
    else
      if session[:authorization] == nil
        redirect_to '/redirect'
      else
        redirect_to '/login'
      end
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end

end

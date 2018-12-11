require 'google/apis/calendar_v3'
require 'date'

class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :create]
  before_action :set_locations, only: [:new, :create]

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
    @users = User.all
    @locations = Location.all
    redirect_to root_path unless @meeting.user == current_user
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = current_user.meetings.new(meeting_params)
    new_event(@meeting)
    respond_to do |format|
      if @meeting.save
        format.html { redirect_to new_event_path, notice: 'Meeting was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  def new_event(meeting)
    client = Signet::OAuth2::Client.new(client_options)
    client.update!(session[:authorization])

    service = Google::Apis::CalendarV3::CalendarService.new
    service.authorization = client

    event = Google::Apis::CalendarV3::Event.new({
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: meeting.start_time.iso8601),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: meeting.end_time.iso8601),
      summary: "#{meeting.agenda}",
      location: "#{meeting.location}"
    })

    service.insert_event("primary", event)
  end

  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.user == current_user && @meeting.update(meeting_params)
        format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        format.json { render :show, status: :ok, location: @meeting }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy if @meeting.user == current_user
    respond_to do |format|
      format.html { redirect_to @meeting.user, notice: 'Meeting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def set_users
    @users = User.all
  end

  def set_locations
    @locations = Location.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def meeting_params
    params.require(:meeting).permit(:user_id, :friend_id, :location_id, :agenda, :start_time, :end_time, :state)
  end

  def client_options
    {
      client_id: Rails.application.secrets.google_client_id,
      client_secret: Rails.application.secrets.google_client_secret,
      authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR,
      redirect_uri: callback_url
    }
  end
end

json.extract! meeting, :id, :user, :friend, :location, :agenda, :start_time, :end_time, :state, :created_at, :updated_at
json.url meeting_url(meeting, format: :json)

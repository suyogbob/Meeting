json.extract! review, :id, :location, :text, :created_at, :updated_at
json.url review_url(review, format: :json)

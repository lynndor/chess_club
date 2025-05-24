json.extract! member, :id, :name, :surname, :email, :birthday, :games_played, :current_rank, :created_at, :updated_at
json.url member_url(member, format: :json)

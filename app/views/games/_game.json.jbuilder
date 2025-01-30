json.extract! game, :id, :title, :genre_id, :platform_id, :created_at, :updated_at
json.url game_url(game, format: :json)

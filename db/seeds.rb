# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Obtener valores únicos de Faker::Game
titles = Faker::Game.fetch_all("game.title")
genres = Faker::Game.fetch_all("game.genre")
platforms = Faker::Game.fetch_all("game.platform")

# Insertar en la base de datos sin duplicados
genres.each { |genre| Genre.find_or_create_by!(name: genre) }
platforms.each { |platform| Platform.find_or_create_by!(name: platform) }
# para crear artículos deben existir genres y platforms
titles.each { |title| Game.find_or_create_by!(
  title: title,
  genre_id: Genre.pluck(:id).sample,
  platform_id: Platform.pluck(:id).sample
)}

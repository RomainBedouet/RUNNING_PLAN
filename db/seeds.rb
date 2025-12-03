# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

default_objectifs = ["Se mettre à la course à pied", "Courir un 10km", "Courir un Semi-marathon", "Courir un marathon", "S'initier au trail"]

user = User.find_or_create_by!(email: "fake@example.com") do |u|
  u.password = "password123"
end

default_objectifs.each do |name|
  Objectif.find_or_create_by!(name: name, user: user)
end

puts "5 objectifs ont été crées"
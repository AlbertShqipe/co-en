# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
DENIS_PASSWARD = ENV['DENIS_PASSWARD']
JURY_PASSWARD = ENV['JURY_PASSWARD']


puts "Destroying existing Users..."
User.destroy_all

puts "Creating new Users..."
puts "................................................................"

# Create admin and jury users for the application.
User.create(
  email: 'denis@entrelace.com',
  password: DENIS_PASSWARD,
  role: 'admin',
  name: 'Denis',
  last_name: 'Lamaj'
)

User.create(
  email: 'jury@entrelace.com',
  password: JURY_PASSWARD,
  role: 'jury',
  name: 'Edi',
  last_name: 'Blloshmi'
)

User.create(
  email: 'albert@gmail.com',
  password: ENV['ALBERT_PASSWARD'],
  role: 'competitor',
  name: 'Albert',
  last_name: 'Nikolli'
)

puts "................................................................"
puts "`#{User.count}` Users created successfully!"

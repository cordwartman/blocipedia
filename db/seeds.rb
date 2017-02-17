require 'faker'

# Create Users
5.times do
  User.create!(
    email:    Faker::Internet.unique.email,
    password: Faker::Internet.password(8)
    )
  end
  users = User.all

# Create Wikis
20.times do
  wiki = Wiki.create!(
    title: Faker::LordOfTheRings.unique.character,
    body: Faker::GameOfThrones.house + ", " + Faker::GameOfThrones.city + ", " + Faker::StarWars.quote + ".",
    user: users.sample,
    private: false
  )
  wiki.update_attribute(:created_at, rand(10.minutes .. 1.year).ago)
end
wikis = Wiki.all

# Create an admin user
admin = User.create!(
  email:    'admin@example.com',
  password: 'password',
  role:     'admin'
)

# Create a Standard user
admin = User.create!(
  email:    'cordwartman@gmail.com',
  password: 'password'
)

# Create a premium user
admin = User.create!(
  email:    'premium@example.com',
  password: 'password',
  role:     'premium'
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"

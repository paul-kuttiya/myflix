# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category = ['comedy', 'drama', 'action']

category.each do |cat|
  Category.create(
    name: cat
  )
end

20.times do
  Video.create(
    title: Faker::Lorem.words(2).join(" "),
    category: Category.all.sample,
    description: Faker::Lorem.paragraph(2),
    small_cover: "/tmp/monk.jpg",
    large_cover: "/tmp/monk_large.jpg"
  )
end

User.create(
  full_name: 'admin',
  email: 'admin@email.com',
  password: 'admin'
)

20.times do
  User.create(
    full_name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

200.times do
  Review.create(
    user: User.all.sample,
    video: Video.all.sample,
    ratings: (1..5).to_a.sample,
    description: Faker::Lorem.paragraph(3)
  )

Review.find(1).update(created_at: 4.days.ago)
end
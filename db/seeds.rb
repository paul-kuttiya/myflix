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

# 20.times do
#   Video.create(
#     title: Faker::Lorem.words(2).join(" "),
#     category: Category.all.sample,
#     description: Faker::Lorem.paragraph(2),
#     small_cover: "/tmp/monk.jpg",
#     large_cover: "/tmp/monk_large.jpg"
#   )
# end

def image_path(file)
  Rails.root.join("app/assets/images/#{file}").open
end

image_path = Rails.root.join("app/assets/images/monk.jpg").open

images = ['family_guy', 'futurama', 'monk']

20.times do
  Fabricate(:video, 
    video_url: "https://www.youtube.com/watch?v=mxhxL1LzKww",
    category: Category.all.sample, 
    small_cover: image_path("#{images.sample}.jpg"), 
    large_cover: image_path("monk_large.jpg")
  )
end

User.create(
  full_name: 'admin',
  email: 'admin@email.com',
  password: 'admin',
  admin: true
)

# 20.times do
#   User.create(
#     full_name: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: Faker::Internet.password
#   )
# end

20.times do
  Fabricate(:user)
end

# 200.times do
#   Review.create(
#     user: User.all.sample,
#     video: Video.all.sample,
#     ratings: (1..5).to_a.sample,
#     description: Faker::Lorem.paragraph(3)
#   )

# Review.find(1).update(created_at: 4.days.ago)
# end

200.times do
  Fabricate(:review, user: User.all.sample, video: Video.all.sample)

  Review.find(1).update(created_at: 4.days.ago)
end

User.all.each do |u|
  10.times do |n|
    QueueItem.create(
      list_order: n,
      video: Video.all.sample,
      user: u,
    )
  end  
end

100.times do |n|
  Relationship.create(
    leader: User.all.sample,
    follower: User.all.sample
  )
end
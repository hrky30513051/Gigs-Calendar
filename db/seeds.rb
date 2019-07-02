# ユーザー
User.create!(name:  "Example Venue",
             email: "examplevenue@gigscalender.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             venue:     true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = "Venue " + Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               venue:     true,
               activated: true,
               activated_at: Time.zone.now)
end

User.create!(name:  "Example User",
             email: "exampleuser@gigscalender.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             venue:     false,
             activated: true,
             activated_at: Time.zone.now)

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  content = "Line up:" << "\n" \
          << Faker::Lorem.word << "\n" \
          << Faker::Lorem.word << "\n" \
          << Faker::Lorem.word << "\n" \
          << "Open 18:00 / Start 19:00"
  event_date = Faker::Date.between(Date.today, 1.year.from_now)
  users.each { |user| user.microposts.create!(content: content, event_date: event_date) }
end

# リレーションシップ
users = User.all
user  = users.first
following = users[1..50]
followers = users[2..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
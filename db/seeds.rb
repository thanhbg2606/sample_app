
User.create!(name: "Admin",

  email: "admin@railstutorial.org",
  password: "123456",
  password_confirmation: "123456",
  admin: true)

10.times do |n|
  name = Faker::Name.name
  email = "testexample-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user1 = User.create(email:"joe.spampinato@gmail.com", username: "joespam", password:"12345678",admin: true)
prof1 = Profile.create(fname: "Joe",lname: "Spampinato",street1: "330 Prussian Lane",street2: "",city: "Wayne",state: "PA",zip: "19087",country: "USA")
user1.profile = prof1
user1.save

user2 = User.create(email:"jcspampinato@gmail.com", username: "josephus", password:"12345678",admin: true)
prof2 = Profile.create(fname: "Joe",lname: "Spampinato",street1: "200 Lincoln Ave",street2: "STE 116",city: "Phoenixville",state: "PA",zip: "19460",country: "USA")
user2.profile = prof1
user2.save

# for testing detection of address from lat long
defaultImg = File.new("#{Rails.root}/app/assets/images/NotwaDefaultPhoto.jpg", "r")
wawa1 = Wawa.new(lat: 39.911590, long: -75.440757, prime_photo: defaultImg)
wawa1.user = user1
wawa1.save
# for testing detection of lat long from address
wawa2 = Wawa.new( street1: "2809 Egypt Rd", city: "Audubon", state: "PA", zip: "19403", prime_photo: defaultImg)
wawa2.user = user2
wawa2.save

wawa1.comments << Comment.create(user_id: user1.id, wawa_id: wawa1.id, body: "I used to buy pretzels here!")
wawa1.comments <<  Comment.create(user_id: user2.id, wawa_id: wawa1.id, body: "I totally did too!")
wawa1.comments <<  Comment.create(user_id: user1.id, wawa_id: wawa1.id, body: "I doubt it; I would know. I was there a lot")
wawa1.comments <<  Comment.create(user_id: user2.id, wawa_id: wawa1.id, body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
wawa1.comments <<  Comment.create(user_id: user1.id, wawa_id: wawa1.id, body: " Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")

wawa2.comments << Comment.create(user_id: user2.id, wawa_id: wawa2.id, body: "This place was pretty lame. Service was terrible")
wawa2.comments <<  Comment.create(user_id: user1.id, wawa_id: wawa2.id, body: "There was actually a party when they closed it")
wawa2.comments <<  Comment.create(user_id: user2.id, wawa_id: wawa2.id, body: "I believe it")
wawa2.comments <<  Comment.create(user_id: user1.id, wawa_id: wawa2.id, body: "They built a gas station one down the road and it's a ton better.")
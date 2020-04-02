User.create(name: "Joe", username: "gardens_of_babylon", email: "test_email@gmail.com", password: "password")
Plant.create(species: "Pseudotsuga Menziesii", user: joe, sprout_date: "03-01-2019", price: 12.99, quantity: 3)
Plant.create(species: "Sequoiadendron Giganteum", user: joe, sprout_date: "03-05-2020", price: 22.99, quantity: 5)
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end

# This will guess the User class
# FactoryGirl.define do
#   factory :user do
#     first_name "John"
#     last_name  "Doe"
#     admin false
#   end

  # This will use the User class (Admin would have been guessed)
#   factory :admin, class: User do
#     first_name "Admin"
#     last_name  "User"
#     admin      true
#   end
# end


# factory_girl supports several different build strategies: build, create, attributes_for and build_stubbed:

# Returns a User instance that's not saved
# user = build(:user)

# Returns a saved User instance
# user = create(:user)

# Returns a hash of attributes that can be used to build a User instance
# attrs = attributes_for(:user)

# Passing a block to any of the methods above will yield the return object
# create(:user) do |user|
#   user.posts.create(attributes_for(:post))
# end


# No matter which strategy is used, it's possible to override the defined attributes by passing a hash:

# Build a User instance and override the first_name property
# user = build(:user, first_name: "Joe")
# user.first_name  => "Joe"


# factory :user do
  # ...
  # activation_code { User.generate_activation_code }
  # date_of_birth   { 21.years.ago }
# end


# Defines a new sequence
# FactoryGirl.define do
  # sequence :email do |n|
    # "person#{n}@example.com"
  # end
# end
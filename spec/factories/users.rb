FactoryGirl.define do
  
  factory :user do    
    password "asdasd"
    email { "#{password}@testing.com" }
  end

end

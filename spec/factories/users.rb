FactoryGirl.define do
  
  factory :user do    
    password "asdasd"
    sequence :email do |n|
      "user#{n}@example.com"
    end
    # email { "#{password}@testing.com" }
  end
  
  factory :confirmed_user do    
    password "asdasd"
    password_confirmation "asdasd"
    email "user@confirmed.com"
  end
  
  factory :user_scripture, class: "Scripture" do
    user
    title "Gods Grace"
    reference "Luke 3:15"
    verse "That whosoever believeth in Jesus should not perish, but have eternal life."
  end
  
end

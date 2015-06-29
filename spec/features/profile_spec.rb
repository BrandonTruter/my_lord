require 'rails_helper'

RSpec.describe "Profile", type: :feature do
  let(:user) { create(:user) }
  # let(:profile) { create(:profile, user: user) }
  
  before(:each) do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'    
  end
    
  it 'can be created' do
    save_and_open_page
    # click_link 'My Profile'
    
    profile = build(:profile, user: user)
    # click_link 'New'
    visit new_user_profile_path(user.id)
    
    within("div.profile_form") do
      
      within("div.left_fields") do
        fill_in "middle_name", with: profile.middle_name
        fill_in "phone", with: profile.phone
        fill_in "gender", with: profile.gender
        fill_in "date_of_birth", with: profile.date_of_birth
      end
    
      within("div.employment_fields") do
        fill_in "qualifications", with: profile.qualifications
        fill_in "net_salary", with: profile.net_salary
        fill_in "company", with: profile.company
        fill_in "position", with: profile.position
        fill_in "occupation", with: profile.occupation
      end
    
      within("div.center_fields") do
        fill_in "married", with: profile.married
        fill_in "family_size", with: profile.family_size
        fill_in "spouse_first_name", with: profile.spouse_first_name
        fill_in "spouse_last_name", with: profile.spouse_last_name
        fill_in "spouse_occupation", with: profile.spouse_occupation
      end
  
      within("div.address_fields") do
        fill_in "street_number", with: profile.street_number
        fill_in "street_name", with: profile.street_name
        fill_in "suburb", with: profile.suburb
        fill_in "city", with: profile.city
        fill_in "province", with: profile.province
        fill_in "postal_code", with: profile.postal_code
      end
    
      within("div.action_fields") do
        click_button "Save"        
      end
      
    end
    
    current_path.should == user_profile_path(user.id, profile.id)
    expect(page).to have_content("Profile saved successfully")
    expect(page).to have_link("Edit")
    expect(page).to have_link("Home")
    
  end    
    
  describe "when new" do

    before(:each) do
      click_link 'My Profile'
    end
    
    scenario 'can be access' do
      click_link 'New'
      save_and_open_page
      current_path.should == new_user_profile_path(user.id)
    end
    

    
    # def update_profile_with(email, password)
        # save_and_open_page
        # fill_in "", with: 
    # end
    
  end
end
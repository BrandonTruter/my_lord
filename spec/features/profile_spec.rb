require 'rails_helper'

RSpec.describe "Profile", type: :feature do
  let(:user) { create(:user) }
  let(:profile) { create(:profile, user: user) }
  
  before(:each) do
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'    
  end
    
  describe "when new" do

    before(:each) do
      click_link 'My Profile'
    end
    
    scenario 'can be access' do
      current_path.should == new_user_profile_path(user.id)
    end
    
    scenario 'can be saved' do
      save_and_open_page
    end
    
    # def update_profile_with(email, password)
    # end
    
  end
end
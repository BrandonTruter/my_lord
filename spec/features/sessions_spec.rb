require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  let(:user) { create(:user) }  
  
  describe 'success' do    
    it 'success with valid details' do
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      
      current_path.should == "/users/#{user.id}"
      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_content(user.email)
      expect(page).to have_link('My info')
      expect(page).to have_link('Sign out')
    end
  end
  
  describe 'failure' do
    before(:each) do
      visit new_user_session_path
    end
  
    it 'failure with invalid email' do
      fill_in 'Email', with: "dsafa@c"
      fill_in 'Password', with: user.password
      click_on 'Log in'
    
      current_path.should == new_user_session_path
      expect(page).to have_content("Invalid email or password")
    end
  
    it 'failure with invalid password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: "asd"
      click_on 'Log in'
    
      current_path.should == new_user_session_path
      expect(page).to have_content("Invalid email or password")
    end
  end
  
end
 
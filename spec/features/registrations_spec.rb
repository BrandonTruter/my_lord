require 'rails_helper'

RSpec.feature "Registrations", type: :feature do

  context 'success' do

    before :each do
      sign_up_with 'user@example.com', 'asdasdasd'
    end

    scenario 'displays flash message' do
      expect(page).to have_content('You have signed up successfully.')
    end
    
    scenario 'displays user information' do
      expect(page).to have_content('user@example.com')
    end
    
    scenario 'displays correct links' do
      expect(page).to have_link('My info')
      expect(page).to have_link('Sign out')
    end  

    def sign_up_with(email, password)
      visit new_user_registration_path

      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirm', with: password
      click_on 'Sign up'
    end
     
  end
  
  context 'failure' do
    
    scenario 'with invalid email address' do
      sign_up_with 'userexample', 'secret', 'secret'
      expect(page).to have_content("Email is invalid Email")
    end
    
    scenario 'with empty email address' do
      sign_up_with '', 'secret', 'secret'
      expect(page).to have_content("Email can't be blank")
    end
    
    scenario 'with invalid password' do
      sign_up_with 'user2@example.com', 'avx2', 'secret'
      expect(page).to have_content("Password is too short")
    end   
    
    scenario 'with empty password' do
      sign_up_with 'user2@example.com', '', 'secret'
      expect(page).to have_content("Password can't be blank")
    end            

    scenario 'with no matching password confirmation' do
      sign_up_with 'user3@example.com', 'secret', 'asd'
      expect(page).to have_content("Password confirmation doesn't match")
    end
      
    def sign_up_with(email, password, confirmation)
      visit new_user_registration_path

      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirm', with: confirmation
      click_on 'Sign up'
    end
    
  end
  
  context 'update' do
    
    before(:each) do
      @user = create(:user)
      visit new_user_session_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_on 'Log in'
      
      current_path.should == user_path(@user.id)
      click_on 'Update Credentials'
    end
    
    scenario 'can be access' do
      current_path.should == edit_user_registration_path(@user.id)
    end
    
    scenario 'can be updated' do
      update_credentials_with("updated@email.com", "password", "password", @user.password)
      
      expect(page).to have_content("Your account has been updated successfully.")
    end
    
    scenario 'fails with empty details' do
      update_credentials_with("", "", "", "")
      
      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Current password can't be blank")
    end
    
    scenario 'fails with passwords that doesnt match' do
      update_credentials_with("updated@email.com", "secret", "fdsadf", @user.password)
      
      expect(page).to have_content("Password confirmation doesn't match")
    end
    
    scenario 'fails with invalid email' do
      update_credentials_with("sadsf.com", "secret", "secret", @user.password)
      
      expect(page).to have_content("Email is invalid")
    end
    
    scenario 'fails with existing email' do
      existing_user = create(:user, email: "existing@user.com", password: "asdasd", password_confirmation: "asdasd")
      
      update_credentials_with(existing_user.email, "secret", "secret", @user.password)
      
      expect(page).to have_content("Email has already been taken")
    end
          
    def update_credentials_with(email, password, confirmation, current)
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Confirm', with: confirmation
      fill_in 'Current', with: current      
      click_on 'Update'
    end    
    
  end  
 
end
 
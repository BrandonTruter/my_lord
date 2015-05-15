require 'rails_helper'

RSpec.describe "Daily Scriptures", type: :feature do
  let(:user) { create(:user) }  
  
  describe "CRUD Functionality" do

    before(:each) do
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      current_path.should == "/users/#{user.id}"
    end

    context 'create' do

      before(:each) do
        click_link 'My Scriptures'
        current_path.should == "/users/#{user.id}/scriptures"
        click_on "New"
      end
      
      it "displays all fields" do
        current_path.should == "/users/#{user.id}/scriptures/new"
        expect(page).to have_content("Title")
        expect(page).to have_content("Reference")
        expect(page).to have_content("Verse")
        expect(page).to have_button("Create")
      end
      
      
      it "can be created" do
        pending
      end
      
    end
    
    # xit "displays a random scripture" do
    # end
    
  end
  
end

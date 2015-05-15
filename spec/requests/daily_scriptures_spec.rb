require 'rails_helper'

RSpec.describe "Daily Scriptures", type: :request do
  
  let(:user) { create(:user) }  
  
  describe "CRUD Functionality" do

    before(:each) do
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    context 'create' do

      before(:each) do
        click_link 'My Scriptures'
        expect(current_path).to == "/users/#{user.id}/scriptures/new"
        click_on "New"
      end
      
      it "displays all scripture fields" do
        expect(page).to have_content("Title")
        expect(page).to have_content("reference")
        expect(page).to have_content("Verse")    
        expect(page).to have_link("Create")
      end
      
      
      xit "creates a new scripture" do
        
      end
      
    end
    
    # xit "displays a random scripture" do
    # end
    
  end
  
end

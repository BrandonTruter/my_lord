require 'rails_helper'

RSpec.describe "Scriptures", type: :feature do
  let(:user) { create(:user) }
  
  describe "CRUD Functionality" do

    before(:each) do
      visit new_user_session_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
      # current_path.should == "/users/#{user.id}"
    end

    describe 'create' do

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
        expect(page).to have_button("Save")
      end      
      
      it "can be created" do
        ref = "John 3:15"
        title = "Everlasting Life"
        verse = "That whosoever believeth in Jesus should not perish, but have eternal life."
          
        fill_in 'Title', with: title
        fill_in 'Reference', with: ref
        fill_in 'Verse', with: verse
        click_on 'Save'
        
        # save_and_open_page
        current_path.should == user_scriptures_path(user.id)
        
        expect(page).to have_link("New")
        expect(page).to have_link("View")
        expect(page).to have_link("Edit")

        expect(page).to have_content(ref)
        expect(page).to have_content("My Scriptures")
        expect(page).to have_content("Successfully saved scripture: #{title}")
      end
      
    end
    
    describe 'read' do
    
      before(:each) do
        @scripture = FactoryGirl.create(:scripture, user: user)
        click_link 'My Scriptures'
      end
    
      it 'displays all scripture information' do
        current_path.should == user_scriptures_path(user.id)
        expect(page).to have_content("My Scriptures")
        expect(page).to have_content(@scripture.title)
        expect(page).to have_content(@scripture.reference)
        expect(page).to have_link("Home")
        expect(page).to have_link("New")
        expect(page).to have_link("View")
        expect(page).to have_link("Edit")
      end
    
      it "displays a random daily scripture" do
        random_verse = @scripture.daily_verse
        expect(find('#daily_scripture')).to have_content(random_verse)
      end
      
      it "displays a selected scripture" do
        click_link 'View'

        expect(page).to have_content(@scripture.title.upcase)
        expect(page).to have_content("Reference")
        expect(page).to have_content(@scripture.reference)
        expect(page).to have_content("Verse")
        expect(page).to have_content(@scripture.verse)
        expect(page).to have_link("Back")
        expect(page).to have_link("Edit")
        expect(page).to have_link("Home")
      end
      
    end
    
    describe 'update' do
    
      before(:each) do
        @scripture = create(:scripture, user: user)
        click_link 'My Scriptures'
        click_link 'Edit'
      end
      
      it 'displays all the fields' do
        expect(page).to have_content("Title")
        expect(page).to have_content("Reference")
        expect(page).to have_content("Verse")
        expect(page).to have_link("Cancel")
        expect(page).to have_button("Update")
      end
      
      it 'can be accesses' do
        current_path.should == edit_user_scripture_path(user.id, @scripture.id)
      end
    
      it 'can be updated' do
        old_title = find_field('Title').value
        
        fill_in 'Title', with: "Updated title"
        fill_in 'Reference', with: "Update reference"
        fill_in 'Verse', with: "Update Verse"
        click_on 'Update'
      
        current_path.should == user_scriptures_path(user.id)        
        expect(page).to have_content("Successfully updated ( #{old_title} ) scripture to ( Updated title )")
      end
      
      xit 'fails with empty details', :js => true do
         Capybara.javascript_driver = :webkit
         
        fill_in 'Title', with: ""
        fill_in 'Reference', with: ""
        fill_in 'Verse', with: ""
        
        click_button 'Update'
    
        # save_and_open_page
    
        expect(page).to have_content("Please provide the scripture's title")    
        expect(page).to have_content("Please provide the scripture's reference")
        expect(page).to have_content("Please provide the scripture's verse")
      end
      
    end    

  end
  
end


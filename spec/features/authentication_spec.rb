# require 'rails_helper'
#
# RSpec.describe 'Authentication', :type => :feature do
#
#   context 'Registration' do
#
#     context 'success' do
#       scenario 'with valid email and password' do
#         sign_up_with 'valid@example.com', 'password'
#         check 'I accept the Terms of Service'
#         click_on 'Sign up'
#
#         expect(page).to have_content('Help My Cash flow Analysis')
#         expect(page).to have_content('Net Wealth')
#         expect(page).to have_link('Signout')
#       end
#     end
#
#     context 'failure' do
#       scenario 'with invalid email' do
#         sign_up_with 'invalid_email@asd', 'password'
#         check 'I accept the Terms of Service'
#         click_on 'Sign up'
#
#         expect(page).to have_content('Email is invalid')
#       end
#
#       scenario 'with blank password' do
#         sign_up_with 'valid@example.com', ''
#         check 'I accept the Terms of Service'
#         click_on 'Sign up'
#
#         expect(page).to have_content("Password can't be blank")
#       end
#
#       scenario 'without accepting terms' do
#         sign_up_with 'valid@example.com', 'password'
#         click_on 'Sign up'
#
#         expect(page).to have_content("Terms of Service must be accepted")
#       end
#     end
#
#     def sign_up_with(email, password)
#       visit new_user_registration_path
#       fill_in 'user_email', with: email
#       fill_in 'user_password', with: password
#       fill_in 'user_password_confirmation', with: password
#       # check 'I accept the Terms of Service'
#       # click_on 'Sign up'
#     end
#   end
#
#   context 'Sessions' do
#
#     context 'success' do
#       scenario 'with valid email and password' do
#         sign_in_with 'john@doe.com', 'secret'
#
#         expect(page).to have_content('My Cash flow Analysis')
#         expect(page).to have_content('Net Wealth')
#         expect(page).to have_link('Signout')
#       end
#
#       it 'logged in should see new budget page' do
#         @user = create(:complete_user)
#         login(@user)
#         expect(page).to have_content("New Budget")
#       end
#     end
#
#     context 'failure' do
#       scenario 'with invalid email' do
#         sign_in_with 'invalid_email@asd', 'secret'
#
#         expect(page).to have_content('Sign in')
#       end
#
#       scenario 'with blank password' do
#         sign_in_with 'valid@example.com', ''
#
#         expect(page).to have_content('Sign in')
#       end
#
#       scenario 'can not recover password for incorrect email' do
#         visit root_path
#         click_on 'Login'
#         fill_in 'Email', with: 'john@doe.com'
#         click_on "Forgot password?"
#         fill_in "Email", with: "no-user@non-existent.com"
#         click_on "Send me password reset instructions"
#         expect(page).to have_content "Email not found"
#       end
#     end
#
#     def sign_in_with(email, password)
#       @user = create(:confirmed_user)
#       visit root_path
#       click_on 'Login'
#       fill_in 'Email', with: email
#       fill_in 'Password', with: password
#       click_on 'Sign in'
#     end
#   end
#
#
#
#
#
#   feature 'if existing' do
#
#     before(:each) do
#       @user = create(:advanced_user)
#       @consultant = create(:consultant_user)
#       visit root_path
#     end
#
#     scenario "can not access admin pages" do
#       login(@user)
#       visit "/admin/users"
#       expect(page).to have_content "You are already signed in."
#     end
#
#     scenario "can not access consultant pages" do
#       login(@user)
#       visit "/users"
#       expect(page).to have_text "Sorry, you have to be logged in as a consultant to do that."
#     end
#
#
#     scenario 'must first accept terms' do
#       # @user.update_column :accept_tos, false
#       @user.accept_tos = false
#       @user.save
#       @user.reload
#       create(:budget, month: Date.today.month, year: Date.today.year, user: @user, state: 'completed')
#
#       login(@user)
#       visit user_url(@user)
#       # expect(page).to have_text("Please accept the Terms to continue.")
#
#       # expect(@user.errors[:accept_tos]).to include("must be accepted")
#       # save_and_open_page
#       # click_on 'data-submit'
#       expect(page).to have_content("Terms of Service must be accepted")
#       fill_in 'Name', with: 'Peter'
#       fill_in 'Surname', with: 'Moore'
#       select('Sanlam', :from => 'Employer')
#       # fill_in 'Employer', with: 'Sanlam'
#
#       fill_in 'user_current_password', with: 'secret'
#       check 'user_accept_tos'
#       click_on 'data-submit'
#       expect(page).to have_content('Profile successfully updated.')
#       expect(page).to have_content "New Budget"
#     end
#
#
#     scenario 'should require a user' do
#       login(@consultant)
#       visit "/users/1"
#
#       expect(page).to have_text "This page requires you to have selected a user to work on."
#     end
#
#   end
#
# end
#
#
# module MyHelper
#   def super_required
#     unless user_signed_in? && current_user.is_super?
#       flash[:error] = "Sorry, you have to be logged in as a super administrator to do that."
#       redirect_to new_user_session_path and return false
#     end
#   end
# end
#
# RSpec.configure {|c| c.include MyHelper }

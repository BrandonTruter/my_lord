require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do

  describe "GET #users" do
    xit "returns http success" do
      get :users
      expect(response).to have_http_status(:success)
    end
  end

end

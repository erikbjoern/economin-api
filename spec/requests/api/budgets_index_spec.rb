RSpec.describe 'GET /api/users/#{user.id}/budgets', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) } 
  let!(:budget) { create(:budget, start_date: Date.today + 15, end_date: Date.today + 45, user_id: user.id) }

  describe 'successfully with valid params' do
    before do
      get "/api/users/#{user.id}/budgets", 
        params: { requested_date: Date.today + 30},
        headers: headers
    end

    it 'gives 200 status code response' do
      expect(response).to have_http_status 200
    end

    it 'returns budget for the requested period' do
      expect(response_json['budget']['id']).to eq budget.id
    end
  end

  describe 'unsuccessfully' do
    describe 'if requested_date param is missing' do
      before do
        get "/api/users/#{user.id}/budgets"
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end
      
      it 'gives error message' do
        expect(response_json['message'])
        .to eq "Please provide a date that's within the time period you are looking for."
      end
    end
    
    describe "if the requested date can't be found within any budget period" do
      it 'gives 404 response' do
        get "/api/users/#{user.id}/budgets", 
          params: { requested_date: Date.today.next_year },
          headers: headers
        
        expect(response).to have_http_status 404
      end
      
      describe 'gives meaningful message' do
        it 'for past dates' do
          get "/api/users/#{user.id}/budgets", 
            params: { requested_date: Date.today.last_year },
            headers: headers
          
          expect(response_json['message'])
          .to eq "You didn't have any budget set for #{Date.today.last_year.strftime("%d %b, %Y")}"
        end

        it "for today's date" do
          get "/api/users/#{user.id}/budgets", 
            params: { requested_date: Date.today },
            headers: headers

          expect(response_json['message'])
          .to eq "You don't have any budget set currently"
        end
        
        it 'for upcoming dates' do
          get "/api/users/#{user.id}/budgets", 
            params: { requested_date: Date.today.next_year },
            headers: headers

          expect(response_json['message'])
          .to eq "You don't have any budget set for #{Date.today.next_year.strftime("%d %b, %Y")}"
        end
      end
    end

    describe "without credentials in headers" do
      before do
        get "/api/users/#{user.id}/budgets", 
          params: { requested_date: Date.today + 30}
      end

      it 'gives 401 status code' do
        expect(response).to have_http_status 401
      end

      it 'gives error message' do
        expect(response_json['errors'][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    describe "trying to access someone else's data" do
      let(:another_user) { create(:user, name: "Another User", email: "another@mail.com") }
      let(:wrong_credentials) { another_user.create_new_auth_token }
      let(:wrong_headers) { { HTTP_ACCEPT: 'application/json' }.merge!(wrong_credentials) } 

      before do
        get "/api/users/#{user.id}/budgets", 
          params: { requested_date: Date.today + 30},
          headers: wrong_headers
      end

      it 'gives 401 status code' do
        expect(response).to have_http_status 401
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "You are trying to access someone else's data"
      end
    end
  end
end
RSpec.describe 'POST /api/budgets', type: :request do
  let(:user) { create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) } 

  describe 'successfully with valid params' do
    before do
      post "/api/users/#{user.id}/budgets", 
        params: {
          amount: 10000,
          start_date: Date.today,
          end_date: Date.today + 30
        },
        headers: headers
    end

    it 'gives 200 status code response' do
      expect(response).to have_http_status 200
    end

    it 'returns the created Budget' do
      budget = Budget.last
      expect(response_json['budget']['id']).to eq budget.id
    end
  end

  describe 'unsuccessfully with invalid params' do
    describe 'amount param missing' do
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            start_date: Date.today,
            end_date: Date.today + 30
          },
          headers: headers
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "Amount can't be blank" 
      end
    end

    describe 'start_date param missing' do
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            amount: 10000,
            end_date: Date.today + 30
          },
          headers: headers
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "Start date can't be blank" 
      end
    end

    describe 'end_date param missing' do
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            amount: 10000,
            start_date: Date.today
          },
          headers: headers
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "End date can't be blank" 
      end
    end

    describe "start date that's occurring before last budget's end date" do
      let!(:budget) { create(:budget, end_date: Date.today.next_year, user_id: user.id) }
      
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            amount: 10000,
            start_date: Date.today,
            end_date: Date.today + 30
          },
          headers: headers
      end

      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message'])
        .to eq "Start date can't be before last budget's end date, which is #{Date.today.next_year}"
      end
    end
    
    describe "end date that's occurring before start date" do
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            amount: 10000,
            start_date: Date.today,
            end_date: Date.today - 30
          },
          headers: headers
      end
        
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "End date can't be before start date"
      end
    end

    describe "without credentials in headers" do
      before do
        post "/api/users/#{user.id}/budgets", 
          params: {
            amount: 10000,
            start_date: Date.today,
            end_date: Date.today + 30
          }
      end

      it 'gives 401 status code' do
        expect(response).to have_http_status 401
      end

      it 'gives error message' do
        expect(response_json['errors'][0]).to eq "You need to sign in or sign up before continuing."
      end
    end
  end
end

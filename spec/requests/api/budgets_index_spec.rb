RSpec.describe 'GET /api/budgets', type: :request do
  let!(:budget) { create(:budget, start_date: Date.today - 15, end_date: Date.today + 15) }

  describe 'successfully with valid params' do
    before do
      get "/api/budgets", params: {
        containing_date: Date.today
      }
    end

    it 'gives 200 status code response' do
      expect(response).to have_http_status 200
    end

    it 'returns budget for the requested period' do
      expect(response_json['budget']['id']).to eq budget.id
    end
  end

  describe 'unsuccessfully' do
    describe 'if containing_date param is missing' do
      before do
        get "/api/budgets"
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end
      
      it 'gives error message' do
        expect(response_json['message'])
        .to eq "Please provide a date that's within the requested budget's time period, in the param 'containing_date'"
      end
    end
    
    describe "if the requested date can't be found within any budget period" do
      before do
        get "/api/budgets", params: {
          containing_date: Date.today.next_year
        }
      end
        
      it 'gives 404 response' do
        expect(response).to have_http_status 404
      end
      
      it 'gives error message' do
        expect(response_json['message']).to eq 'No budget could be found for the requested period'
      end
    end
  end
end
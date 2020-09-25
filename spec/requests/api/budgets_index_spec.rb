RSpec.describe 'GET /api/budgets', type: :request do
  let!(:budget) { create(:budget, start_date: Date.today + 15, end_date: Date.today + 45) }

  describe 'successfully with valid params' do
    before do
      get "/api/budgets", params: { requested_date: Date.today + 30}
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
        get "/api/budgets"
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
        get "/api/budgets", params: { requested_date: Date.today.next_year }
        expect(response).to have_http_status 404
      end
      
      describe 'gives meaningful message' do
        it 'for past dates' do
          get "/api/budgets", params: { requested_date: Date.today.last_year }
          
          expect(response_json['message'])
          .to eq "You didn't have any budget set for #{Date.today.last_year.strftime("%d %b, %Y")}"
        end

        it "for today's date" do
          get "/api/budgets", params: { requested_date: Date.today }

          expect(response_json['message'])
          .to eq "You don't have any budget set currently"
        end
        
        it 'for upcoming dates' do
          get "/api/budgets", params: { requested_date: Date.today.next_year }

          expect(response_json['message'])
          .to eq "You don't have any budget set for #{Date.today.next_year.strftime("%d %b, %Y")}"
        end
      end
    end
  end
end
RSpec.describe 'POST /api/budgets', type: :request do
  describe 'successfully with valid params' do
    before do
      post '/api/budgets', params: {
        amount: 10000,
        start_date: Date.today,
        end_date: Date.today + 30
      }
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
        post '/api/budgets', params: {
          start_date: Date.today,
          end_date: Date.today + 30
        }
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
        post '/api/budgets', params: {
          amount: 10000,
          end_date: Date.today + 30
        }
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
        post '/api/budgets', params: {
          amount: 10000,
          start_date: Date.today
        }
      end
      
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "End date can't be blank" 
      end
    end

    describe "start date that's occurring before last budget's end date" do
      let!(:budget) { create(:budget, end_date: Date.today.next_year) }
      
      before do
        post '/api/budgets', params: {
          amount: 10000,
          start_date: Date.today,
          end_date: Date.today + 30
        }
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
        post '/api/budgets', params: {
          amount: 10000,
          start_date: Date.today,
          end_date: Date.today - 30
        }
      end
        
      it 'gives 400 response' do
        expect(response).to have_http_status 400
      end

      it 'gives error message' do
        expect(response_json['message']).to eq "End date can't be before start date"
      end
    end
  end
end

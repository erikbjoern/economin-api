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

    describe 'start_date occurring before previous end_date' do
      let(:budget) { create(:budget, end_date: Date.today + 10)}
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
        expect(response_json['message']).to eq "Start date cannot be sooner than previous end date"
      end
    end
    
    describe 'end_date occurring before start_date' do
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
        expect(response_json['message']).to eq "End date cannot be sooner than start date"
      end
    end
  end
end

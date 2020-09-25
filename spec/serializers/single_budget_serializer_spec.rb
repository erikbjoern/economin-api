RSpec.describe SingleBudgetSerializer, type: :serializer do
  let!(:budget) { create(:budget) }

  before do
    serializer = SingleBudgetSerializer.new(budget)
    @hash = serializer.as_json
  end

  it 'has root "budget"' do
    expect(@hash).to have_key :budget
  end

  it 'has keys id, amount, start_date and end_date' do
    expected_keys = %i[id amount start_date end_date]
    expect(@hash[:budget].keys).to match expected_keys
  end
end
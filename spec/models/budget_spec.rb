RSpec.describe Budget, type: :model do
  
  describe 'database table' do
    it { should have_db_column :amount }
    it { should have_db_column :start_date }
    it { should have_db_column :end_date }
  end
  
  describe 'validations' do
    it { should validate_presence_of :amount }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :end_date }
      
    it "validates that start date is not before last budget's end date" do
      last_budget = create(:budget, amount: 123, start_date: '2020-09-22', end_date: '2020-10-22')
      subject.start_date = '2020-09-22'
      subject.end_date = '2020-11-22'
      subject.valid?
      expect(subject.errors[:start_date]).to include("can't be before last budget's end date, which is #{last_budget.end_date}")
      subject.start_date = '2020-10-22'
      subject.valid?
      expect(subject.errors[:start_date]).to_not include("can't be before last budget's end date, which is #{last_budget.end_date}")
    end

    it 'validates that end date is not before start date' do
      subject.start_date = '2020-09-22'
      subject.end_date = '2020-09-21'
      subject.valid?
      expect(subject.errors[:end_date]).to include("can't be before start date")
      subject.end_date = '2020-09-22'
      subject.valid?
      expect(subject.errors[:end_date]).to_not include("can't be before start date")
    end
  end

  describe 'relations' do
    it { should belong_to :user }
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(create(:budget)).to be_valid
    end
  end
end

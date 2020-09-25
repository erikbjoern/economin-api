RSpec.describe User, type: :model do 
  describe 'database table' do
    it { should have_db_column :name}
    it { should have_db_column :email }
    it { should have_db_column :encrypted_password }
  end
  
  describe 'relations' do
    it { should have_many :budgets }
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(create(:user)).to be_valid
    end
  end
end
require 'rails_helper'

RSpec.describe Budget, type: :model do
  
  describe 'db columns' do
    it { is_expected.to have_db_columns :amount, :start_date, :end_date }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of :amount, :start_date, :end_date }

    describe 'before_save #validate_start_date' do
      it 'does not allow start date that is sooner than previous end date' do
        expect do
          create(:budget, start_date: "2020-09-22", end_date: "2020-10-22")
          create(:budget, start_date: "2020-09-22", end_date: "2020-11-22")
        end
          .to raise_error StandardError, 'Start date must be later than previous end date!'
      end
    end

    describe 'before_save #validate_end_date' do
      it 'does not allow end date that is sooner than start date' do
        expect do
          create(:budget, start_date: "2020-09-22", end_date: "2020-08-22")
        end
          .to raise_error StandardError, 'End date must be later than start date!'
      end
    end
  end

  describe 'factory' do
    it 'should have a valid factory' do
      expect(create(:budget)).to be_valid
    end
  end
end

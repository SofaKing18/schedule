# test User's model and methods

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:all) do
    @user = User.new(
      email: 'example@example.com',
      password: '12345678',
      password_confirmation: '12345678'
    )
  end
  it 'FIO fields need not' do
    expect(@user.save!).to eq(true)
  end
  it 'but we can fill values and save FIO fields' do
    @user.last_name = 'James'
    @user.middle_name = 'J.'
    @user.first_name = 'March'
    expect(@user.save!).to eq(true)
  end
end

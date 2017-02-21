require 'rails_helper'

RSpec.describe EventNotificatorMailer, type: :mailer do
  before :all do
    @user = User.first_or_create(
      email: 'example@example.com',
      password: '12345678',
      password_confirmation: '12345678'
      );
    UserEvent.create(user_id: @user.id, name: 'abc', start_date: Date.tomorrow)
  end

  it "user created" do
    puts @user.inspect
    expect(@user.id).to be_truthy
  end

  it "should prepare email with notification for tomorrow" do
    expect(EventNotificatorMailer.dont_forget(@user).presence.class).to eq(Mail::Message)
    # Mail::Message is ready for deliver object, NullMail for example is not
  end

end

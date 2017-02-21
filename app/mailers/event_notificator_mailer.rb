# EventNotificatorMailer
class EventNotificatorMailer < ApplicationMailer
  default from: 'dont_forget@schedul3r.herokuapp.com'

  def dont_forget(user, date = Date.tomorrow.strftime('%Y.%m.%d'), mail = nil)
    @user = user
    @date = date
    @events = UserEvent.event_in_day(date, @user.id).rows.select do |row|
      row[1] == @user.id
    end
    if @events.empty?
      message.perform_deliveries = false
    else
      mail(to: mail || @user.email, subject: "Event(s) at #{date} ")
    end
  end
end

if Rails.env.production?
  send_dont_forget_mails = Rufus::Scheduler.new
  send_dont_forget_mails.cron ENV['cron_mail'] do
    User.find_each.each do |us|
      EventNotificatorMailer.dont_forget(us).deliver_now
    end
  end
end

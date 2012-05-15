class UserMailer < ActionMailer::Base
  default from: "saagarvarma18@gmail.com"

  def welcome_email(user)
    @user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered")
  end

end

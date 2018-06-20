class UserMailer < ApplicationMailer
  default from: 'no_reply.treasury.app@ultroneous.org'

  def welcome_email
    @user = params[:user]
    @url  = 'http://treasury.ultroneous.org/login'
    mail(to: "nuno.de.meireles@gmail.com", subject: 'Welcome to Veda Tresury Web App')
  end
end

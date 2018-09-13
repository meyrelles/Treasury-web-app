class UserMailer < ApplicationMailer
  default from: 'no_reply@ultroneous.org'

  @address = "localhost"
  @port = 25

  def welcome_email
    @user = params[:user]
    @url  = 'https://treasury.ultroneous.org/login'
    delivery_options = {
               :address              => "localhost",
               :port                 => 25,
               :enable_starttls_auto => true
              }

    mail(from: "no_reply@ultroneous.org", reply_to: "no_reply@ultroneous.org" ,to: @user.email, subject: 'Welcome to Veda Tresury Web App',
        delivery_method_options: delivery_options)
  end

  def approved_user
    @user = params[:user]
    @url  = 'https://treasury.ultroneous.org/login'
    delivery_options = {
               :address              => "localhost",
               :port                 => 25,
               :enable_starttls_auto => true
              }

    mail(from: "no_reply@ultroneous.org", reply_to: "no_reply@ultroneous.org" ,to: @user.email, subject: 'Welcome to Veda Tresury Web App',
        delivery_method_options: delivery_options)
  end

  def reset_password
    @user = params[:user]
    @url  = 'https://treasury.ultroneous.org/password_reset'
    delivery_options = {
               :address              => "localhost",
               :port                 => 25,
               :enable_starttls_auto => true
              }

    mail(from: "no_reply@ultroneous.org", reply_to: "no_reply@ultroneous.org" ,to: @user.email, subject: 'Treasury web app - Reset password',
        delivery_method_options: delivery_options)
  end

  def approve_user_email
    @user = params[:user]
    @url  = 'https://treasury.ultroneous.org/users/' + @user.id + '/edit'
    delivery_options = {
               :address              => "localhost",
               :port                 => 25,
               :enable_starttls_auto => true
              }

    mail(from: "no_reply@ultroneous.org", reply_to: "no_reply@ultroneous.org" ,to: 'nuno.de.meireles@gmail.com', subject: 'Please check new user to approve',
        delivery_method_options: delivery_options)
  end
end

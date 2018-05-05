class SessionsController < ApplicationController
  require 'yaml'

  def new
  end

  def create
    #user = User.find_by(username: params[:session][:username].to_s)
    user = User.where(username: params[:session][:username].to_s)
    pass = User.where(username: params[:session][:username].to_s).map(&:password_digest)*",".to_s

    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = 'CCEKvUgNbXByO6eAp2pgb56Nur/E16tHA1cYY2Ofai8='
    key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    pass = crypt.decrypt_and_verify(pass)

    if user && params[:session][:"password"].to_s == pass
      log_in user
      flash[:info] = "Welcome to treasury app"
      redirect_to tr_statements_path
    else
      flash[:danger] = 'Invalid username/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

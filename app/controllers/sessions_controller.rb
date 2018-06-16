class SessionsController < ApplicationController
  require 'yaml'

  def new
  end

  def create
    user = User.where(username: params[:session][:username].to_s)
    pass = User.where(username: params[:session][:username].to_s).map(&:password_digest)*",".to_s
    verified = User.where(username: params[:session][:username].to_s).map(&:verified)*",".to_s

    if pass != ''
      salt  = 'CCEKvUgNbXByO6eAp2pgb56Nur/E16tHA1cYY2Ofai8='
      key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)
      pass = crypt.decrypt_and_verify(pass, purpose: :login)
    end

    if user && params[:session][:"password"].to_s == pass && pass != '' && verified.to_s == "true"
      log_in user
      flash[:info] = "Welcome to treasury app"
      redirect_to tr_statements_path
    else
      if verified.to_s != "true"
        flash[:danger] = 'User not yet verified, contact Veda member.' # Not quite right!
        render 'new'
      else
        flash[:danger] = 'Invalid username/password combination' # Not quite right!
        render 'new'
      end
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end

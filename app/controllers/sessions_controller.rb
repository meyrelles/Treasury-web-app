class SessionsController < ApplicationController

    def new
    end

    def create
      #user = User.find_by(username: params[:session][:username].to_s)
      user = User.where(username: params[:session][:username].to_s)
      pass = User.where(username: params[:session][:username].to_s).map(&:password_digest)*",".to_s
      user_pass = $crypt.decrypt_and_verify(pass)

      if user && user_pass == params[:session][:password].to_s
        log_in user
        #flash[:danger] = user
        #redirect_to '/users/' + User.where(username: params[:session][:username].to_s).map(&:id)*",".to_s
        redirect_to tr_statements_path
        #redirect_to user
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

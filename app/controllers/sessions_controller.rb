class SessionsController < ApplicationController

    def new
    end

    def create
      user = User.where(username: params[:session][:username])
      pass = User.where(password_digest: (Digest::SHA2.hexdigest(SecureRandom.base64(8) + params[:session][:"password"])))
      flash[:danger] = pass.to_s
      if user && pass
        log_in user
        redirect_to user

      # if user && user.authenticate(params[:session][:password])
        # Log the user in and redirect to the user's show page.
      else
        flash[:danger] = 'Invalid username/password combination' # Not quite right!
        render 'new'
      end
    end

    def destroy
    end
end

module SessionsHelper

  # Logs in the given user.
  def log_in(user)
    id = User.where(username: params[:session][:username].to_s).map(&:id)*",".to_s
    session[:user_id] = id
    session[:admin] = User.where(username: params[:session][:username].to_s).map(&:admin)
    session[:verified] = User.where(username: params[:session][:username].to_s).map(&:verified)
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= User.where(id: session[:user_id])
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end

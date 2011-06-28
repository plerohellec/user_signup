class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user_session, :current_user

  # authlogic opens a session as soon as the user is created
  # even if he doesn't yet have a password.
  # that's wrong, nuke it.
  before_filter :no_password_no_session

  def no_password_no_session
    if current_user && current_user.crypted_password.blank?
      logger.debug "destroying current session"
      #@current_user_session.destroy
      @current_user = nil
    end
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    logger.debug "redirect_back_or_default: #{session[:return_to]}"
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Used in before_filter to make sure the logged in user
  # can only view/modify his own profile
  def check_authorization
    # sanity check
    raise "No current user in check_authorization filter??" unless current_user

    if(params[:id].to_i != current_user.id)
      flash[:error] = "You're not authorized for that URL"
      redirect_to root_path
    end
  end
end

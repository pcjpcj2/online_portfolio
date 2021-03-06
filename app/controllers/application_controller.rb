class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  after_filter :store_location
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :layouts) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :email, :password, :remember_me, :layouts) }
      devise_parameter_sanitizer.for(:account_update ) { |u| u.permit(:fullname, :username, :location, :website, :facebook, :twitter, :bio, :current_password) }
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    projects_path
  end

  def after_sign_out_path_for(resource)
    root_path
  end

end

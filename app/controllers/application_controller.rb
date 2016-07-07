class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def custom_user_authentication_show(check)
    if !check.users.include?(current_user)
      redirect_to :root
      return
    end
  end
  def custom_user_authentication_else(check)
    if !check.users.include?(current_user)
      false
    else
      true
    end
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :about, :email, :password, :remember_me) }
  end




  #mobile preferences
  protect_from_forgery

      before_filter :set_mobile_preferences
      before_filter :redirect_to_mobile_if_applicable
      before_filter :prepend_view_path_if_mobile

      private

      def set_mobile_preferences
        if params[:mobile_site]
          cookies.delete(:prefer_full_site)
        elsif params[:full_site]
          cookies.permanent[:prefer_full_site] = 1
          redirect_to_full_site if mobile_request?
        end
      end

      def prepend_view_path_if_mobile
        if mobile_request?
          prepend_view_path Rails.root + 'app' + 'mobile_views'
        end
      end

      def original_url
        base_url + original_fullpath
      end

      def redirect_to_full_site
        redirect_to request.protocol + request.host_with_port.gsub(/^m\./, '') and return
      end

      def redirect_to_mobile_if_applicable
        unless mobile_request? || cookies[:prefer_full_site] || !mobile_browser?
        redirect_to request.protocol + 'm.' + request.host_with_port.gsub(/^www\./, '') and return
          #redirect_to request.protocol + "m." + request.host_with_port.gsub(/^www\./, '') +
           #request.original_url and return
          # redirect_to 'm.grouper.biz' and return
          #redirect_to :root
        end
      end

      def mobile_request?
        request.subdomains.first == 'm'
      end
      helper_method :mobile_request?

      def mobile_browser?
        request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android)/]
      end
      helper_method :mobile_browser?

end

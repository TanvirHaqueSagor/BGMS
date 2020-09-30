class ApplicationController < ActionController::Base
    
    # before_action :authenticate_user
    helper_method :current_user
    helper_method :logged_in?
    def current_user
       Admin.find_by(userid: session[:userid])
    end
    def logged_in?
        !current_user.nil?
    end  
    def authenticate_user 
            redirect_to admin_login_path unless logged_in?
    end  
    
    def authenticate_manager
        redirect_to main_menu_index_path unless current_user.auth_type.eql? '管理者'
    end  
end

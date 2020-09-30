class AdminController < ApplicationController
  before_action :authenticate_user, except: :login
  before_action :authenticate_manager, except: :login
  
  def index
    @admin = Admin.new
    @save_status="initial"
  end
  def saveinfo
    @save_status="initial"
    if request.post?
      @admin = Admin.new(admin_params)
      if @admin.password != @admin.conf_password
        @save_status="pass_mismatch"  
        render 'index'
      elsif Admin.exists?(userid: @admin.userid) 
        @save_status="alrady"  
        render 'index'
      elsif Admin.exists?(email: @admin.email) 
        @save_status="email_alrady"  
        render 'index'
      elsif !validate_password_format(@admin.password)
        @save_status="pass_invalid"  
        render 'index'
      elsif @admin.save 
         @admin = Admin.new 
         @save_status="success"
         render 'index'
      else
        if @admin.errors.any?
          @save_status="initial"
        else
          @save_status="failed"
        end 
        render 'index'
      end 
    else
      redirect_to admin_index_path
    end
  end
  def login
    @login_status="initial"
    @logininfo = Logininfo.new 
    session[:userid] =  "0"
    if request.post?
      @logininfo = Logininfo.new (logininfo_params)
      if @logininfo.userid.blank?
        @login_status="blank_userid"
        render 'login'
      elsif @logininfo.password.blank?
        @login_status="blank_password"
        render 'login'
      else 
        @admin = Admin.where( "(userid = :userid or email = :userid) and password = :password", { userid: @logininfo.userid, password: @logininfo.password }).pluck(:userid) 
        if @admin.size>0
          session[:userid] = @admin[0]
          redirect_to main_menu_index_path
        else
          @login_status="failed"
          render 'login'
        end
      end
    end
  end
  
  def validate_password_format(password)
    matching_case = 0
    if !password.blank?
      if password.match? (/[a-z]+/) #Lowecase latter
        matching_case = matching_case + 1 
      end
      if password.match? (/[A-Z]+/) #Uppercase latter
        matching_case = matching_case + 1 
      end
      if password.match? (/\d+/) #digit
        matching_case = matching_case + 1 
      end
      if password.match? (/[^A-Za-z0-9]+/) #symbol
        matching_case = matching_case + 1 
      end
      if(matching_case>=3)
        return true
      end
    end
     return false
  end

  private
  def admin_params
    params.require(:admin).permit( :name, :userid, :group, :email, :auth_type, :password, :conf_password)
  end
  
  private
  def logininfo_params
    params.require(:logininfo).permit( :userid, :password)
  end
end

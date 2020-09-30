class RegistrationController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_manager
  
  def index
    @user = User.new
    @save_status='initial'
    @birthPlace_array = birth_place
    @user.birthPlace = '出身地選択'
    @user.registrationNo = generate_reg_number

  end

  def clear
    redirect_to  registration_index_path;
  end
  def saveinfo
    if request.post?
      @user = User.new(user_params)
      if User.exists?(registrationNo: @user.registrationNo) 
        @save_status='failed'
        @birthPlace_array = birth_place
        @user.registrationNo = generate_reg_number 
        render 'index'
      elsif @user.save
        #  Sends registration confirmation email
        admins =Admin.all
        admins.each do |admin| 
          if !admin.email.blank? 
          NotificationMailer.with(user: @user, email: admin.email ,reciver: admin.name , admin: current_user).send_save_notification_mail.deliver_now!
          end
        end  

         @birthPlace_array = birth_place
         @user.birthPlace = '出身地選択'
         @user = User.new
         @user.registrationNo = generate_reg_number
         @save_status='success'
         render 'index'
      else
        if @user.errors.any?
          @save_status='initial'
        else
          @save_status='failed'
        end
        @birthPlace_array = birth_place
        @user.registrationNo = generate_reg_number
        render 'index'
      end 
    else
      redirect_to registration_index_path
    end
  end
  
  private
  def user_params
    params.require(:user).permit( :registrationNo, :kanjiName, :kanaName, :dateOfBirth, 
                                  :birthPlace,   :height, :weight, :image, :specialSkill,
                                  :hobby, :charmPoint, :holidyTimeSpand, :appealPoint, :score)
  end
  private
  def birth_place
     [ '出身地選択', '青森県', '岩手県', '宮城県', '秋田県',  '山形県', '福島県', '茨城県', '栃木県',
       '群馬県', '埼玉県', '千葉県', '東京都',  '神奈川県', '新潟県', '富山県', '石川県',   '福井県',
       '山梨県', '長野県', '岐阜県', '静岡県', '愛知県', '三重県', '滋賀県', '京都府', '大阪府',
       '兵庫県', '奈良県', '和歌山県', '鳥取県', '島根県', '岡山県', '広島県', '山口県', '徳島県',
       '香川県', '愛媛県', '高知県', '福岡県', '佐賀県', '長崎県', '熊本県', '大分県', '宮崎県',
       '鹿児島県', '沖縄県']  
  end
  private
  def generate_reg_number
    already_registered_no = User.pluck(:registrationNo)
    generated_uniq_reg_no = 0
    while generated_uniq_reg_no <= 0 
      code = rand(7**10)
      while code.to_s.length != 7
        code = rand(8**10) 
      end
      generated_uniq_reg_no = code unless already_registered_no.include? code
    end
    generated_uniq_reg_no
  end
  
end

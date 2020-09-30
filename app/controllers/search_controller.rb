class SearchController < ApplicationController
  before_action :authenticate_user
  before_action :authenticate_manager ,only: [:update, :save_updated_info, :delete]

  @@global_searchinfo = SearchInfo.new
  @@global_update_Status = 'init'
  @@update_reg_no = 0
  def new
    @birthPlace_array = birth_place
    @searchinfo = SearchInfo.new
    @searchinfo.birthPlace = '出身地選択'
    # @foundUsers =   User.new
    @error ='init'
  end

  def find
    if request.post?
      @searchinfo = SearchInfo.new(searchinfo_params)
      @birthPlace_array = birth_place
      @@global_searchinfo = @searchinfo
      @error ='init'
      if @searchinfo.errors.any?
        # @searchresult = SearchInfo.new
        @searchresult = User.new
      else
        if !@searchinfo.kanjiName.blank?
          if !@searchinfo.kanjiName.match? (/[\u4E00-\u9FAF]/)
            @error = 'kanji' 
          end
        end
        if !@searchinfo.kanaName.blank?
          if !@searchinfo.kanaName.match? (/[\u3040-\u309F]|[\u30A0-\u30FF]/)
             @error = 'kana' 
          end
        end
        if @error == 'init'
          @searchresult = search_for_user (@searchinfo)
        end
      end
      render 'new'
    else
      redirect_to search_new_path;
    end
  end

  def clear
    redirect_to  search_new_path;
  end
  def back
    @searchinfo = @@global_searchinfo
    @searchresult = search_for_user (@@global_searchinfo)
    @birthPlace_array = birth_place
    @error ='init'
    render 'new'
  end
  def show
    url = Rails.application.routes.recognize_path(request.referrer)
    last_visited(url[:action], url[:controller])
    @user =  User.find_by(registrationNo: params[:registrationNo]);
    @birthPlace_array = birth_place
  end
  def update
    @user =  User.find_by(registrationNo: params[:registrationNo]);
    @birthPlace_array = birth_place
    @update_status = @@global_update_Status
    # global
    @@global_update_Status = 'init'
    @@update_reg_no = params[:registrationNo];
  end
  def save_updated_info 
    if request.post?
      inputed_user = User.new(user_params)
       user = User.find_by(registrationNo: inputed_user.registrationNo)
        #calculate the number of updated column
       updated_column = calculate_updated_column(user, inputed_user)
       user.update(user_params)
        if user.errors.any?
          
          @user = user  
          # @user.image = User.select
          # @user.image = params[:image]     #blank
          # @user.image.attach(params[:image])

          @birthPlace_array = birth_place
          render 'update'
        else
         @@global_update_Status = 'updated'  
          #  Sends Updated Notifiaction email
          admins =Admin.all
          admins.each do |admin| 
            if !admin.email.blank? 
            NotificationMailer.with(user: user, email: admin.email ,reciver: admin.name , admin: current_user, updated_column: updated_column).send_update_notification_mail.deliver_now!
            end
          end  
        
         redirect_to  search_update_path(:registrationNo => user.registrationNo);
        end
    else
      @@global_update_Status = 'init'  
      redirect_to  search_update_path(:registrationNo => @@update_reg_no);
    end
  end


  def delete
    user = User.find_by(registrationNo: params[:registrationNo])
    destroyed = User.where(registrationNo: params[:registrationNo]).destroy_all
    if (destroyed.length > 0)
    @delete_status = 'deleted'
     #  Sends delete motification email
     admins =Admin.all
     admins.each do |admin| 
       if !admin.email.blank? 
       NotificationMailer.with(user: user, email: admin.email ,reciver: admin.name , admin: current_user).send_delete_notification_mail.deliver_now!
       end
     end  
    else
    @delete_status = 'failed'
    end
  end

  private
  def searchinfo_params
    params.require(:searchinfo).permit( :regNoFrom, :regNoTo, :kanjiName, :kanaName, :dateOfBirthFrom,
                                        :dateOfBirthTo, :birthPlace, :scoreFrom, :scoreTo)
  end
  private
  def user_params
    params.require(:user).permit( :id, :registrationNo, :kanjiName, :kanaName, :dateOfBirth, 
                                  :birthPlace,   :height, :weight, :image, :specialSkill,
                                  :hobby, :charmPoint, :holidyTimeSpand, :appealPoint, :score)
  end

  def search_for_user  (searchinfo) 
    quary = '' 
    if !searchinfo.kanjiName.blank?
      quary += '"kanjiName" = \'' + searchinfo.kanjiName + '\''
    end
    # if searchinfo.kanaName != ''  
      if !searchinfo.kanaName.blank?
      quary = quary_and(quary)
      quary += '"kanaName" = \'' + searchinfo.kanaName + '\''
    end

    if !searchinfo.regNoFrom.blank?
      quary = quary_and(quary)
      quary += '"registrationNo" >=  \'' + searchinfo.regNoFrom + '\''
    end
    
    if !searchinfo.regNoTo.blank?
      quary = quary_and(quary)
      quary += '"registrationNo" <=  \'' + searchinfo.regNoTo + '\''
    end

    if !searchinfo.dateOfBirthFrom.blank?
      quary = quary_and(quary)
      quary += '"dateOfBirth" >=  \'' + searchinfo.dateOfBirthFrom + '\''
    end

    if !searchinfo.dateOfBirthTo.blank?
      quary = quary_and(quary)
      quary += '"dateOfBirth" <=  \'' + searchinfo.dateOfBirthTo + '\''     
    end

    if !searchinfo.scoreFrom.blank?
      quary = quary_and(quary)
      quary += '"score" >=  \'' + searchinfo.scoreFrom + '\''
    end

    if !searchinfo.scoreTo.blank?
      quary = quary_and(quary)
      quary += '"score" <=  \'' + searchinfo.scoreTo + '\'' 
    end

    if searchinfo.birthPlace != '出身地選択' and (!searchinfo.birthPlace.blank?)
      quary = quary_and(quary)
      quary += '"birthPlace" =  \'' + searchinfo.birthPlace + '\''
    end

    foundUsers =   User.where(quary)
  end

  def quary_and (quary)
    if quary.length > 1  
      quary += ' and '
   end
   quary
  end

  #calculate the number of updated column
  def calculate_updated_column(saved_user, inputed_user)
    result = '、'; 
    unless saved_user.registrationNo.eql? inputed_user.registrationNo
      result  =  result  + "登録No、"
    end
    unless saved_user.kanjiName.eql? inputed_user.kanjiName
      result  =  result  + "名前(漢字)、"
    end
    unless saved_user.kanaName.eql? inputed_user.kanaName
      result  =  result  + "名前(かな)、"
    end
    unless saved_user.dateOfBirth.eql? inputed_user.dateOfBirth
      result  =  result  + "生年月日、"
    end
    unless saved_user.birthPlace.eql? inputed_user.birthPlace
      result  =  result  + "出身地、"
    end
    unless saved_user.height.eql? inputed_user.height
      result  =  result  + "身長、"
    end
    unless saved_user.weight.eql? inputed_user.weight
      result  =  result  + "体重、"
    end
    unless saved_user.specialSkill.eql? inputed_user.specialSkill
      result  =  result  + "特技、"
    end
    unless saved_user.hobby.eql? inputed_user.hobby
      result  =  result  + "趣味、"
    end
    unless saved_user.charmPoint.eql? inputed_user.charmPoint
      result  =  result  + "チャームポイント、"
    end
    unless saved_user.holidyTimeSpand.eql? inputed_user.holidyTimeSpand
      result  =  result  + "休日の過ごし方、"
    end
    unless saved_user.appealPoint.eql? inputed_user.appealPoint
      result  =  result  + "アピールポイント、"
    end
    unless saved_user.score.eql? inputed_user.score
      result  =  result  + "採点　、"
    end 
    if result.length >1 
      n = result.size
      result = result[0..n-2]
    end
    result
  end


# store the last visited controller action 
  def last_visited(action_name, controller_name)
    if(action_name =='find' and controller_name == 'search')
        session[:action]='back'
        session[:controller]=controller_name
    elsif(action_name =='index' and controller_name == 'main_menu')
        session[:action]=action_name
        session[:controller]=controller_name
    end
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
end

class NotificationMailer < ApplicationMailer
    def send_save_notification_mail
        email=  params[:email]
        @user = params[:user]
        @reg_admin = params[:admin]
        @reciver = params[:reciver]
        subject = "【新規】新しい美少女が登録されました（氏名："+ @user.kanjiName + "）"
            mail(to: email, subject: subject) 
    end
    def send_update_notification_mail
        email=  params[:email]
        @user = params[:user]
        @reg_admin = params[:admin]
        @reciver = params[:reciver]
        @updated_column = params[:updated_column]
        subject = "【変更】美少女情報が更新されました氏名："+ @user.kanjiName + "）"
            mail(to: email, subject: subject) 
    end
    def send_delete_notification_mail
        email=  params[:email]
        @user = params[:user]
        @reg_admin = params[:admin]
        @reciver = params[:reciver]
        subject = "【削除】美少女情報が削除されました（氏名："+ @user.kanjiName + "）"
            mail(to: email, subject: subject) 
    end
end

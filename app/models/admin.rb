class Admin < ApplicationRecord
    validates :name, presence: { message: "入力していない項目があります！" }
    validates :userid, presence: { message: "入力していない項目があります！" }
    validates_format_of :userid, with: /\A[a-zA-Z0-9]+\z/, message:"入力情報を確認して、正しい値を入力してください!",  on: :create
    validates :email, presence: { message: "入力していない項目があります！" }
    validates_format_of :email, with: /\A[a-zA-Z0-9]+\z/, message:"入力情報を確認して、正しい値を入力してください!",  on: :create
    validates :group, presence: { message: "入力していない項目があります！" }
    validates :auth_type, exclusion: { in: ['権限を選択'], message: "入力していない項目があります！" }
    validates :password, presence: { message: "入力していない項目があります！" }
    validates :password, length: { minimum: 8, message: "パスワードは８桁以上記入してください！" }
    validates :conf_password, presence: { message: "入力していない項目があります！" }
    validates :conf_password, length: { minimum: 8, message: "確認用パスワードは８桁以上記入してください！" }
end

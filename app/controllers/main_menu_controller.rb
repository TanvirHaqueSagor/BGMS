class MainMenuController < ApplicationController
  before_action :authenticate_user
  def index
    # @searchresult = User.where("created_at >= :start_date",{start_date: DateTime.yesterday  })
    @searchresult = User.where("created_at >= :start_date",{start_date: DateTime.now.days_ago(3) }).order(created_at: :desc)
    # @searchresult = User.where("created_at >= :start_date",{start_date: DateTime.now.days_ago(3) }).group_by_day(:created_at).count

   if @searchresult.count < 1
    @searchresult = nil
   end
  end
end

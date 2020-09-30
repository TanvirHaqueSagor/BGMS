class AddEmailToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :email, :string
  end
end

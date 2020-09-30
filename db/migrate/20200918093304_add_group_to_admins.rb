class AddGroupToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :group, :string
  end
end

class AddGroupToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :group, :string
  end
end

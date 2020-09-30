class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.text :name
      t.string :userid, unique: true
      t.text :auth_type
      t.text :password
      t.text :conf_password

      t.timestamps
    end
  end
end

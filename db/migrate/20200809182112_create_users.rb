class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :registrationNo
      t.text :kanjiName
      t.text :kanaName
      t.date :dateOfBirth
      t.text :birthPlace
      t.decimal :height
      t.decimal :weight
      t.text :image
      t.text :specialSkill
      t.text :hobby
      t.text :charmPoint
      t.text :holidyTimeSpand
      t.text :appealPoint
      t.integer :score

      t.timestamps
    end
  end
end

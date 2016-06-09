class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.decimal :examMark
      t.decimal :schoolAverage
      t.boolean :isRecommended
      t.boolean :isForeign
      t.string :speciality
      t.string :secondSpeciality
      t.string :finalSpeciality
      t.string :group
      t.string :turn

      t.timestamps null: false
    end
  end
end

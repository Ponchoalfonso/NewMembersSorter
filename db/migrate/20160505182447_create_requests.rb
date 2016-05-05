class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :name
      t.decimal :examMark
      t.decimal :schoolAverage
      t.boolean :isRecommended
      t.boolean :isForeign
      t.integer :speciality
      t.integer :secondSpeciality

      t.timestamps null: false
    end
  end
end

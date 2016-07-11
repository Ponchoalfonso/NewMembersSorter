class CreateRestos < ActiveRecord::Migration
  def change
    create_table :restos do |t|
      t.string :name
      t.decimal :examMark
      t.decimal :schoolAverage
      t.boolean :isRecommended
      t.boolean :isForeign
      t.string :speciality
      t.string :secondSpeciality
      t.timestamps null: false
    end
  end
end

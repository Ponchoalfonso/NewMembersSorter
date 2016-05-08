class CreateElectroMas < ActiveRecord::Migration
  def change
    create_table :electro_mas do |t|
      t.string :name
      t.decimal :examMark
      t.timestamps null: false
    end
  end
end

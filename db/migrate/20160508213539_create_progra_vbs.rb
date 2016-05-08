class CreatePrograVbs < ActiveRecord::Migration
  def change
    create_table :progra_vbs do |t|
      t.string :name
      t.decimal :examMark
      t.timestamps null: false
    end
  end
end

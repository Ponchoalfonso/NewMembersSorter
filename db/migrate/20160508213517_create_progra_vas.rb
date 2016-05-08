class CreatePrograVas < ActiveRecord::Migration
  def change
    create_table :progra_vas do |t|
      t.string :name
      t.decimal :examMark
      t.timestamps null: false
    end
  end
end

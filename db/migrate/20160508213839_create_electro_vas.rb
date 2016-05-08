class CreateElectroVas < ActiveRecord::Migration
  def change
    create_table :electro_vas do |t|
      t.string :name
      t.decimal :examMark
      t.timestamps null: false
    end
  end
end

class CreateContaMas < ActiveRecord::Migration
  def change
    create_table :conta_mas do |t|
      t.string :name
      t.decimal :examMark
      t.timestamps null: false
    end
  end
end

class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :status

      t.timestamps null: false
    end
  end
end

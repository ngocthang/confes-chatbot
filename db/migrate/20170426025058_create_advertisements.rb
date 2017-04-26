class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.text :content
      t.boolean :active

      t.timestamps null: false
    end
  end
end

class CreateUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :urls do |t|
      t.string :short_url
      t.string :original_url
      t.integer :stats, default: 0

      t.timestamps
    end
  end
end

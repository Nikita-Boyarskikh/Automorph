class AddIndexToCache < ActiveRecord::Migration[5.1]
  def change
    add_index :caches, :n, unique: true
  end
end

class CreateCaches < ActiveRecord::Migration[5.1]
  def change
    create_table :caches do |t|
      t.string :error
      t.string :result

      t.timestamps
    end
  end
end

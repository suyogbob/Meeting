class CreateReviews < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.references :location
      t.text :text

      t.timestamps
    end
  end
end

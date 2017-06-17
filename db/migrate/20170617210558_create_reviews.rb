class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :description
      t.integer :user_id
      t.integer :video_id
      t.integer :ratings
      t.timestamps
    end
  end
end

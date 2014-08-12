class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts, id: :uuid do |t|

      t.string :title, limit: 4096
      t.text :content
      t.uuid :user_id

      t.timestamps
    end
  end
end

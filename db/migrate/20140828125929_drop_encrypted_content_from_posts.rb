class DropEncryptedContentFromPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :encrypted_content
    remove_column :posts, :content
    add_column :posts, :content, :bytea
  end

  def down
    remove_column :posts, :content
    add_column :posts, :content, :varchar
    add_column :posts, :encrypted_content, :bytea
  end


end


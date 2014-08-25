class AddEncryptedContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :encrypted_content, :bytea
  end
end

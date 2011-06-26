class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email,            :null => false
      t.string :first_name
      t.string :last_name
      t.string :hashed_password
      t.date   :birth_date
      t.string :location
      t.string :uuid,             :null => false  # used for signup URL
      t.string :password_salt,       :null => false
      t.string :persistence_token,   :null => false

      t.timestamps
    end

    add_index :users,  :email, :unique => true
    add_index :users,  :uuid,  :unique => true

    create_table :jobs do |t|
      t.integer :user_id,     :null => false
      t.string :title
      t.string :company_name
      t.date :joined_at
      t.date :left_at

      t.timestamps
    end

    add_index :jobs, :user_id
  end

  def self.down
    drop_table :users
    drop_table :jobs
  end
end

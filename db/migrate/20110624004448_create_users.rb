class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :hashed_password
      t.date :birth_date
      t.string :location

      t.timestamps
    end

    create_table :jobs do |t|
      t.integer :user_id
      t.string :title
      t.string :company_name
      t.date :joined_at
      t.date :left_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :jobs
  end
end

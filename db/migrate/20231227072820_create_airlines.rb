class CreateAirlines < ActiveRecord::Migration[7.0]
  def change
    create_table :airlines do |t|
      t.string :name, null: false # 航空会社名
      t.string :login_name, null: false # ログイン名
      t.string :password, null: false # パスワード
      t.string :password_confirmation, null: false # 確認用パスワード

      t.timestamps
    end
  end
end

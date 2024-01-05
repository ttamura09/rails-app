table_names = %w(customers administrators airlines airports airmodels seats flights bookings booking_seat_flights) # シードデータを追加したいテーブルをここに追加
table_names.each do |table_name|
  path = Rails.root.join("db/seeds", Rails.env, table_name + ".rb")
  if File.exist?(path)
    puts "Creating #{table_name}..."
    require path
  end
end
airline_names = %w(JAL ANA PEACH) # 航空会社（便名に使用）
dep_time = Time.current.advance(days: -15).beginning_of_day - 3.hours # 出発日時の変数定義（7行目の都合で-3hours）
duration = 0 # 所要時間（分）
random = Random.new # 飛行機のクラスを決める
0.upto(30) do
  # 30日分データ作成
  dest = 1 # 出発地IDと到着地IDのズレ
  dep_time = dep_time + 9.hours # 飛行機の始発便は6時設定（21:00から6:00にするため＋9hours）
  10.upto(39) do |flight_num|
    # 便番号の下二桁
    orig = flight_num % 8 # 出発地ID
    0.upto(2) do |alnum|
      # 航空会社ID
      #↓↓↓出発地IDと到着地ID（同じ出発地が続かないように出発地と到着地それぞれにalnumを足す形にしている）↓↓↓
      orig_dest_ids = [(orig + alnum) % 8, (orig + alnum + dest) % 8]
      dest = dest + 1
      if dest == 8
        # 出発地IDと到着地IDが同じにならないようにする（出発と到着IDのズレ!=0）
        dest = 1
      end

      # 以下、所要時間と値段設定----------
      if orig_dest_ids.include?(0)
        # 新千歳←→
        if orig_dest_ids.include?(1) || orig_dest_ids.include?(2) || orig_dest_ids.include?(3)
          # 羽田・成田・中部
          price = 8000
          duration = 120
        elsif orig_dest_ids.include?(4) || orig_dest_ids.include?(5)
          # 関空・伊丹
          price = 11000
          duration = 140
        elsif orig_dest_ids.include?(6)
          # 福岡
          price = 13000
          duration = 170
        else
          # 那覇
          price = 19000
          duration = 250
        end

      elsif orig_dest_ids.include?(1) || orig_dest_ids.include?(2)
        # 羽田・成田←→
        if orig_dest_ids.include?(3) || orig_dest_ids.include?(4) || orig_dest_ids.include?(5)
          # 中部・関空・伊丹
          price = 7000
          duration = 75
        elsif orig_dest_ids.include?(6)
          # 福岡
          price = 10000
          duration = 125
        elsif orig_dest_ids.include?(7)
          # 那覇
          price = 10000
          duration = 180
        else
          # 羽田←→成田
          price = 5000
          duration = 30
        end

      elsif orig_dest_ids.include?(3)
        # 中部←→
        if orig_dest_ids.include?(6)
          # 福岡
          price = 8000
          duration = 100
        elsif orig_dest_ids.include?(7)
          # 那覇
          price = 12000
          duration = 150
        else
          # 関空・伊丹
          price = 5000
          duration = 30
        end

      elsif orig_dest_ids.include?(4) || orig_dest_ids.include?(5)
        # 関空・伊丹←→
        if orig_dest_ids.include?(6)
          # 福岡
          price = 6000
          duration = 80
        elsif orig_dest_ids.include?(7)
          # 那覇
          price = 10000
          duration = 140
        else
          # 関空←→伊丹
          price = 5000
          duration = 30
        end

      else
        # 福岡←→那覇
        price = 7000
        duration = 100
      end

      Flight.create(
        name: "#{airline_names[alnum]}#{alnum + 1}#{flight_num}便", # 便番号の百の位は航空会社(1:JAL 2:ANA 3:PEACH)
        airline_id: alnum + 1,
        airmodel_id: random.rand(1..3),
        departure_date: dep_time.to_date,
        departure_time: dep_time,
        arrival_date: (dep_time + duration.minutes).to_date,
        arrival_time: (dep_time + duration.minutes),
        origin_id: orig_dest_ids[0] + 1,
        destination_id: orig_dest_ids[1] + 1,
        operation: true,
        price: price
      )

      dep_time = dep_time + 10.minutes # 10分ごとに出発していく（6本/h、30*3本/日、最終20:50発）
    end
  end
end

class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  belongs_to :airmodel

  has_many :bookings
  has_many :booking_seat_flights

  class << self
    # フライト検索用メソッド
    def search(origin_id, destination_id, departure_date, min_price, max_price, time, selected_time_type, selected_class)
      results = order("id")

      # 出発地・到着地の絞り込み
      if origin_id.present? && destination_id.present?
        results = results.where(origin_id: origin_id, destination_id: destination_id)
      end

      # 出発日の絞り込み
      if departure_date.present?
        results = results.where("departure_date = ?", departure_date)
      end

      # 下限料金の絞り込み
      if min_price.present?
        if selected_class == "エコノミー"
          min_price = min_price.to_i - 0
        elsif selected_class == "ビジネス"
          min_price = min_price.to_i - 2000
        else
          min_price = min_price.to_i - 10000
        end
        results = results.where("price >= ?", min_price)
      end

      # 上限料金の絞り込み
      if max_price.present?
        if selected_class == "エコノミー"
          max_price = max_price.to_i - 0
        elsif selected_class == "ビジネス"
          max_price = max_price.to_i - 2000
        else
          max_price = max_price.to_i - 10000
        end
        results = results.where("price <= ?", max_price)
      end

      # 時刻の絞り込み(出発)
      if time.present? && selected_time_type.present?
        time = Time.parse("2000-01-01 #{time}")
        results = results.where("#{selected_time_type}_time >= ?", time)
      end

      results
    end
  end
end

class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  belongs_to :airmodel

  has_many :bookings
  has_many :booking_seat_flights

  def sum_price(seat_class)
    seat = airmodel.seats.find_by(seat_class: seat_class)
    seat_price = seat&.price || 0
    price + seat_price
  end

  def calc_seat_nums(seat_class)
    economy_nums, business_nums, first_nums = [airmodel.economy_nums, airmodel.business_nums, airmodel.first_nums]
    booking_seat_flights.each do |booking_seat_flight|
      if booking_seat_flight.seat.seat_class == "economy"
        economy_nums -= 1
      elsif booking_seat_flight.seat.seat_class == "business"
        business_nums -= 1
      else
        first_nums -= 1
      end
    end

    if seat_class == "economy"
      res = economy_nums
    elsif seat_class == "business"
      res = business_nums
    else
      res = first_nums
    end
    res
  end

  class << self
    # フライト検索用メソッド
    def search(params)
      results = order("id")

      # 出発地・到着地の絞り込み
      if params[:origin].present? && params[:destination].present?
        results = results.where(origin_id: params[:origin], destination_id: params[:destination])
      end

      # 出発日の絞り込み
      if params[:departure_date].present?
        results = results.where("departure_date = ?", params[:departure_date])
      end

      # 下限料金の絞り込み
      if params[:min_price].present?
        min_adj = case params[:seat_class]
                  when "economy" then 0
                  when "business" then 2000
                  else 10000
                  end
        min_price = params[:min_price].to_i - min_adj
        results = results.where("price >= ?", min_price)
      end

      # 上限料金の絞り込み
      if params[:max_price].present?
        max_adj = case params[:seat_class]
                  when "economy" then 0
                  when "business" then 2000
                  else 10000
                  end
        max_price = params[:max_price].to_i - max_adj
        results = results.where("price <= ?", max_price)
      end

      # (出発 or 到着)時刻の絞り込み
      if params[:time].present? && params[:selected_time_type].present?
        time = Time.parse("2000-01-01 #{params[:time]}")
        results = results.where("#{params[:selected_time_type]}_time >= ?", time)
      end

      results
    end

  end
end

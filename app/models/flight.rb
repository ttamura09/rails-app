class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  belongs_to :airmodel

  has_many :bookings
  has_many :booking_seat_flights
  has_many :seats, through: :booking_seat_flights

  validates :name, presence: true
  validates :airline_id, presence: true
  validates :origin_id, presence: true
  validates :destination_id, presence: true
  validates :airmodel_id, presence: true
  validates :departure_date, presence: true
  validates :departure_time, presence: true
  validates :arrival_date, presence: true
  validates :arrival_time, presence: true
  validates :price, presence: true

  scope :operation, -> { where(operation: 1) }

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
      elsif booking_seat_flight.seat.seat_class == "first"
        first_nums -= 1
      end
    end

    if seat_class == "economy"
      res = economy_nums
    elsif seat_class == "business"
      res = business_nums
    elsif seat_class == "first"
      res = first_nums
    else
      res = economy_nums + business_nums + first_nums
    end
    res
  end

  def seat_status_mark(seat)
    seat_status = booking_seat_flights.find_by(seat_id: seat.id)
    if seat_status.nil?
      "⚪︎" # 予約可能
    elsif seat_status.checkin
      "☑️︎" # チェックイン完了
    else
      "×" # 予約済み
    end
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
        if params[:seat_class].present?
          min_adj = adj_price(params[:seat_class])
        else
          min_adj = 10000
        end
        min_price = params[:min_price].to_i - min_adj
        results = results.where("price >= ?", min_price)
      end

      # 上限料金の絞り込み
      if params[:max_price].present?
        if params[:seas_class].present?
          max_adj = adj_price(params[:seat_class])
        else
          max_adj = 0
        end
        max_price = params[:max_price].to_i - max_adj
        results = results.where("price <= ?", max_price)
      end

      # 出発・到着時刻の絞り込み
      if params[:time].present? && params[:selected_time_type].present?
        time = Time.parse("2000-01-01 #{params[:time]}")
        if params[:selected_time_type] == "departure"
          results = results.where("departure_time >= ?", time)
        else
          results = results.where("arrival_time <= ?", time)
        end
      end
      results
    end

    private def adj_price(seat_class)
      case seat_class
      when "economy" then 0
      when "business" then 2000
      else 10000
      end
    end
  end
end

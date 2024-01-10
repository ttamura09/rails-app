class TopController < ApplicationController
  def index
    @flights = Flight.order("id").where(operation: 0)
  end
end

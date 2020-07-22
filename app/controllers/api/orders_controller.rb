module Api 
  class OrdersController < BaseController
    def show 
      json_response(
        OrderSerializer.new(order).serializable_hash.to_json
      ) 
    end 

    private 

    def order 
      @order ||= Order.find(params[:id])
    end 
  end
end 

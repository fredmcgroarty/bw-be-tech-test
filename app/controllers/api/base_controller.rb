class Api::BaseController < ApplicationController
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    json_response({ message: e.message }, :not_found)
  end

  private 

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end 

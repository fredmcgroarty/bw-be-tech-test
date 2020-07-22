require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  describe '#show' do 
    context 'when the record is found' do 
      it 'returns a 200' do 
        order = create(:order)
        get :show, params: { id: order.id } 
        expect(response).to have_http_status(:ok)
      end 
    end 
    context 'when the record is not found' do 
      it 'returns a 404' do 
        get :show, params: { id: 'whev' }
        expect(response).to have_http_status(:not_found)
      end 
    end 
  end 
end

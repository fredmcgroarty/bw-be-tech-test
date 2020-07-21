require 'rails_helper'

RSpec.describe OrderType, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:max_deliveries) }
end


desc "Takes a date (YYYY-MM-DD) and creates a delivery object for all billable orders going out on that day"
task :shipping, [:date] => :environment do |task, args|
  date = Date.new(
    *args[:date].split('.').map(&:to_i)
  )

  orders = OrderFinder.new(date: date, state: :billed).perform
  
  puts "#{orders.size} Billed orders due on #{date.to_s(:long)}:"
  puts " "

  incomplete_orders = []
  complete_orders = [] 

  orders.each do |order|
    
    DeliveriesCreator.new(order: order).perform

    if OrderCompleter.new(order).perform
      complete_orders << order 
      puts "* Order #{order.id} created. #{order.deliveries.count} Deliveries created"
      order.deliveries.each_with_index do |delivery, index|
        puts "   #{index + 1}. delivery due on #{delivery.delivery_date.to_s(:long)}"
      end 
    else
      incomplete_orders << order 
    end
  end 
  puts " "
  puts "#{complete_orders.size} Billed Orders now set to Complete" if orders.any?

  if incomplete_orders.any?
    puts "The following orders could not complete:"
    incomplete_orders.each { |order| puts "#{order.id}" } 
  end 
  puts " "
end

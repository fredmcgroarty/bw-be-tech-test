
desc "Takes a date (YYYY-MM-DD) and creates a delivery object for all billable orders going out on that day"
task :shipping, [:date] => :environment do |task, args|

  date = Date.parse(*args[:date])

  orders = OrderFinder.new(date: date, state: :billed).perform
  
  puts "\n #{orders.size} Billed orders due on #{date.to_s(:long)}:"

  next if orders.empty?
  
  incomplete_orders = []
  complete_orders = [] 

  puts "\n What national holidays should free shipping be exlcuded for? \n Select a number."
  
  UKPublicHolidayFetcher::SUBDIVISIONS.each_with_index do |region, index| 
    puts "#{index + 1}. #{region.humanize}"
  end 

  answer = STDIN.gets.chomp
  
  subdivision =  UKPublicHolidayFetcher::SUBDIVISIONS[Integer(answer) - 1]
  puts "\n region #{subdivision} selected." 

  excluded_delivery_dates = UKPublicHolidayFetcher.new(
    filter_past_dates: true, 
    subdivision: subdivision
  ).perform 

  orders.each do |order|
  
    if order.shipping_option.available_on_public_holidays?  
      DeliveriesCreator.new(order: order).perform 
    else 
      DeliveriesCreator.new(excluded_delivery_dates: excluded_delivery_dates,  
                            order: order).perform 
    end 

    if OrderCompleter.new(order).perform 
      complete_orders << order 
      
      puts "* Order #{order.id} completed. #{order.deliveries.count} Deliveries created"
      
      order.deliveries.each_with_index do |delivery, index|
        puts "   #{index + 1}. delivery due on #{delivery.delivery_date.to_s(:long)}"
      end 
    else
      incomplete_orders << order 
    end
  end 

  puts " \n #{complete_orders.size} Billed Orders now set to Complete" if orders.any?


  if incomplete_orders.any?
    puts " \n The following orders could not complete: \n"
    incomplete_orders.each { |order| puts "#{order.id}" } 
  end

end

goods = {}

loop do
    puts "Введите название товара(для подсчета суммы введите \"стоп\" или \"stop\"):"
    goods_name = gets.chomp
    break if goods_name == "стоп" || goods_name == "stop"

    if goods[goods_name].nil?
      puts "Введите цену за единицу товара:"
      price = gets.chomp.to_f

      puts "Введите количество товара:"
      count = gets.chomp.to_f

      goods[goods_name] = {price: price, count: count}
    else
      puts "Данный товар уже есть в корзине. Введите количество, которое будет добавлено к существующему товару в корзине:"
      count = gets.chomp.to_f
      goods[goods_name][:count] += count
    end
end

if goods.size > 0
    puts "============"
    i = 1
    total_sum = 0
    goods.each {|goods_name, attr|
        price = attr[:price]
        count = attr[:count]
        sum = price * count
        total_sum += sum
        puts "#{i}. #{goods_name} \t #{price.to_s} x #{count.to_s} = #{sum.to_s}"
        i += 1
    }
    puts "============"
    puts "Итого: #{total_sum.to_s}"
else
    puts "В вашей корзине нет товаров"
end
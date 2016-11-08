fibonachi_numbers = [0, 1]
current_index = 1
loop do
    new_number = fibonachi_numbers[current_index-1] + fibonachi_numbers[current_index]
    break if new_number >= 100
    fibonachi_numbers << new_number
    current_index += 1    
end
puts fibonachi_numbers
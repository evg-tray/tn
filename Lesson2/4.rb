hash_result = {}
vowels = "aeiou"
i = 1
("a".."z").each { |l| 
    hash_result[l] = i if vowels.include?(l)
    i += 1
}
puts hash_result
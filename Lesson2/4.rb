hash_result = {}
vowels = "aeiou".split("")
alphabet = "a".."z"

vowels.each { |l| hash_result[l] = alphabet.find_index(l).next }
puts hash_result
require 'pry'

dwarves = ['happy', 'grumpy', 'dopey', 'sleepy' 'bashful' 'doc' 'sneezy']

dwarves.each do |dwarf|
	puts "High ho! I am #{dwarf.capitalize}"
end	

numbers = [1,2,3,4,5,6,7]

squares = []
numbers_each do |number|
   square  = numbers * number
   squares.push(square)
end

squares = numbers.map do |number|
	number * number
end

 #  puts "The square of #{number} is #{square}"
 # squares = [1,4,9,16.25.36.49]



squares = []
numbers_each do |number|
	square = number * number
	squares.push(square)
end	



	# squares = [1,4,9,16,25,36,49]

	less_than_4 = []
     numbers.each do |number|
     	if number < 4
     		less_than_4.push(number)
        end		
    end

    less_than_4 = numbers.select do |number|
	 	number < 4
	 end 	

	 binding.pry

	 less_than_4 = [1,2,3]	
      


      
      # numbers_each do	
       #squares = numbers.map do [number]
	  #number * number

	 #how to select
	 #less_than_4 = numbers.select do |number|
	 	#number < 4
	 #end	

#PROGRAMMERS: Joao Engel, Brendon Amino, Teran Upchurch
#DATE: 10/09/24
#FILE: wumpus.rb

# A text-based game where players navigate a 6x4 maze to hunt the Wumpus.
# Players can move or shoot to defeat the Wumpus while avoiding deadly pits.
# Sensory cues indicate nearby dangers, and the game features random placement
# of the Wumpus and pits for varied experiences.

#This is the defintion of our Base class
class Tile
	#this is how we define a class method
	def what
		"O"
	end
end

#Derived1 inherits from Base
class Pit < Tile
	#what is an example of a polymorphic method
	def what 
		"P"
	end
end

#Derived2 also inherits from Base
class Wumpus < Tile
	#what is an example of a polymorphic method
	def what 
		"W"
	end
end	

#The Composition class is composed of objects from Base, Derived1, and Derived2
class Composition
	attr_accessor :arr; 	#this is how you create a class variable (attribute) in Ruby
				#arr is encapsulated inside of the Composition class
	#initialize() is equivalent to a constuctor in C++
	def initialize()
		@maze = [	
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new,], 
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new,],
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new,], 
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new,]
    ]
		#NOTE: In methods you put the @ symbol in front of member variables
		#This is how Ruby knows it is the member variable and not a local variable
	end

	#prints the contents of arr to the screen
	def printArray
		for r in 0..3 do
			for c in 0..5 do
				print "#{@maze[r][c].what} "
			end
			puts ""
		end
	end

	#prints the object in arr at row and col
	def objectAtIn2Darray(row, col)
		if row >= 0 and row < 2 and col >= 0 and col < 2
			puts "Item at (#{row},#{col}) is #{@arr[row][col].what}"
		else
			puts "That row and column is out of bounds!"
		end
	end

	#prints a random object in arr to the screen
	def randomObjectIn2Darray
		row = rand(2); #rand(2) generates a random number from 0 to 1
		col = rand(2); #rand(2) generates a random number from 0 to 1
		puts "Item at (#{row},#{col}) is #{@arr[row][col].what}"
	end

	def doStuff
		choice = "5"
		while choice != "4"
			puts "What do you want to do:"
			puts " 1) Print object in the array at a specific row and column"
			puts " 2) Print a random object in the array"
			puts " 3) Print the entire array"
			puts " 4) Quit"
			print "ENTER CHOICE: "
			choice = gets.chomp #.chomp removes the newline from the input
			if choice == "1"
				print "What row do you want to see (enter 0 or 1): "
				row = gets.chomp.to_i #remove new line and convert to an integer
				print "What col do you want to see (enter 0 or 1): "
				col = gets.chomp.to_i #remove new line and convert to an integer
				objectAtIn2Darray(row, col)
			elsif choice == "2"
				randomObjectIn2Darray
			elsif choice == "3"
				printArray
			elsif choice == "4"
				puts "Bye!"
			else
				puts "Invalid choice!"
			end
		end
	end
end

#this is the main program body
c = Composition.new #create a new Composition object called c
c.doStuff #call the method doStuff of object c

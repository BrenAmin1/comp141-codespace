#PROGRAMMER: Joao Engel, Brendon Amino, Teran Upchurch
#DATE: 10/09/24
#FILE: wumpus.rb
#This file provides a short example of how to code in Ruby

# A text-based game where players navigate a 6x4 maze to hunt the Wumpus.
# Players can move or shoot to defeat the Wumpus while avoiding deadly pits.
# Sensory cues indicate nearby dangers, and the game features random placement
# of the Wumpus and pits for varied experiences.
#This is the defintion of our Base class

=begin
this is a test
multi-line comment
yippie
woohoo
hooray!
=end

class MyTest
	THIS_IS_A_CONSTANT = "IM A CONSTANT"
end

class Tile
	#this is how we define a class method
	def type
		"O"
	end
end

#Derived1 inherits from Base
class Pit < Tile
	#type is an example of a polymorphic method
	def type 
		"P"
	end
end

#Derived2 also inherits from Base
class Wumpus < Tile
	#type is an example of a polymorphic method
	def type 
		"W"
	end
end	

#The Composition class is composed of objects from Base, Derived1, and Derived2
class Composition
	attr_accessor :maze; 	#this is how you create a class variable (attribute) in Ruby
				#arr is encapsulated inside of the Composition class
	#initialize() is equivalent to a constuctor in C++
	def initialize()
		@maze = [	
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new], 
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new],
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new], 
        [Tile.new, Tile.new, Tile.new, Tile.new, Tile.new, Tile.new]
    ]
		#NOTE: In methods you put the @ symbol in front of member variables
		#This is how Ruby knows it is the member variable and not a local variable
	end

	#prints the contents of arr to the screen
	def printArray
		for r in 0..3 do
			for c in 0..5 do
				print "#{@maze[r][c].type} "
			end
			puts ""
		end
	end

	#prints the object in arr at row and col
	def objectAtIn2Darray(row, col)
		if row >= 0 and row < 2 and col >= 0 and col < 2
			puts "Item at (#{row},#{col}) is #{@arr[row][col].type}"
		else
			puts "That row and column is out of bounds!"
		end
	end

	# Initialize the maze by randomly placing pits and a wumpus
	def initMaze
		# Places four pits (one per row)
		for r in 0..3
			col = rand(1..5) #rand(2) generates a random number from 0 to 1
			@maze[r][col] = Pit.new
		end
		# Places the wumpus
		row = rand(0..3)
		col = rand(1..5)
		while @maze[row][col].type == "P"
			row = rand(0..3)
			col = rand(1..5)
		end
		@maze[row][col] = Wumpus.new
	end

	def doStuff
		choice = "O"
		while choice != "q"
			printArray
			puts ""
			puts "type do you want to do:"
			puts " u) Move Up"
			puts " d) Move Down"
			puts " l) Move Left"
			puts " r) Move Right"
			puts " s) Shoot Arrow"
			puts " q) Quit"
			print "ENTER CHOICE: "
			choice = gets.chomp #.chomp removes the newline from the input
			if choice == "s"
				puts "type direction do you want to shoot your arrow: "
				puts " u) Shoot Up"
				puts " d) Shoot Down"
				puts " l) Shoot left"
				puts " r) Shoot right"
				print "ENTER CHOICE: "
				shotDirection = gets.chomp

				if shotDirection == "u"
					# shoot arrow up
				elsif shotDirection == "d"
					# shoot arrow down
				elsif shotDirection == "l"
					# shoot arrow left
				elsif shotDirection == "r"
					# shoot arrow right
				else
					puts "Invalid choice!"
					# maybe continue
				end	
				# print "type col do you want to see (enter 0 or 1): "
				# col = gets.chomp.to_i #remove new line and convert to an integer
				# objectAtIn2Darray(row, col)
				
			elsif choice == "u"
				# move character up
				randomObjectIn2Darray
			elsif choice == "d"
				# move character down
				printArray
			elsif choice == "l"
				# move character left
				printArray
			elsif choice == "r"
				# move character right
				printArray
			elsif choice == ""
				puts "Invalid choice!"
			else
				puts "Invalid choice!"
			end
		end
	end
end

#this is the main program body
c = Composition.new #create a new Composition object called c
c.initMaze
c.doStuff #call the method doStuff of object c

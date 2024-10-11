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
	attr_accessor :tileAction
	@tileAction = ""
	def SetAction(action)
		@tileAction = action
	end

	def GetAction
		@tileAction
	end
end

class EmptyTile < Tile
	def type
		"O"
	end
	
	
end

class Pit < Tile
	def type 
		"P"
	end
end

class Wumpus < Tile
	def type 
		"W"
	end
end	


#The Composition class is composed of objects from Base, Derived1, and Derived2
class Composition
	attr_accessor :maze 
	attr_accessor :playerRow
	attr_accessor :playerCol
	def initialize()
		@maze = [	
        [EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new], 
        [EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new],
        [EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new], 
        [EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new, EmptyTile.new]
    ]
		@playerRow = 3
		@playerCol = 0
		#NOTE: In methods you put the @ symbol in front of member variables
		#This is how Ruby knows it is the member variable and not a local variable
	end

	#prints the contents of arr to the screen
	def printMaze
		for r in 0..3 do
			for c in 0..5 do
				print "#{@maze[r][c].type} "
			end
			puts ""
		end
	end

	def printMap
		for r in 0..3 do
			for c in 0..5 do
				if r == @playerRow and c == @playerCol
					print "X"
				else
					print "O"
				end
			end
		puts ""
		end
	end

	def playerMove(letter)
		if letter == 'u' and @playerRow > 0
			@playerRow -= 1 #Move up	
		elsif letter == 'd' and @playerRow < 3
			@playerRow += 1 #Move down
		elsif letter == 'l' and @playerCol > 0
			@playerCol -= 1 #Move left
		elsif letter == 'r' and @playerCol < 5
			@playerCol += 1 #Move right
		else
			print "\nOuch! You ran into a wall\n" #Collision with wall
		end
		checkMove(@playerRow, @playerCol)
	end

	def checkMove(row, col)
		if row > 0
			print @maze[row - 1][col].GetAction
		end
		# check for bottom tile
		if row < 3
			print @maze[row + 1][col].GetAction
		end
		# check for left tile
		if col > 0
			print @maze[row][col - 1].GetAction
		end
		# check for right tile
		if col < 5
			print @maze[row][col + 1].GetAction
		end
	end

	def playerShoot(letter)
		if row > 0
			
		end
		# check for bottom tile
		if row < 3
			
		end
		# check for left tile
		if col > 0
			
		end
		# check for right tile
		if col < 5
			
		end
	end

	# #prints the object in arr at row and col
	# def objectAtIn2Darray(row, col)
	# 	if row >= 0 and row < 2 and col >= 0 and col < 2
	# 		puts "Item at (#{row},#{col}) is #{@arr[row][col].type}"
	# 	else
	# 		puts "That row and column is out of bounds!"
	# 	end
	# end

	# Initialize the maze by randomly placing pits and a wumpus
	def initMaze
		# Places four pits (one per row)
		for r in 0..3
			col = rand(1..5) #rand(2) generates a random number from 0 to 1
			@maze[r][col] = Pit.new
			addActionsToTile(r, col, "P")
		end
		# Places the wumpus
		row = rand(0..3)
		col = rand(1..5)
		while @maze[row][col].type == "P"
			row = rand(0..3)
			col = rand(1..5)
		end
		@maze[row][col] = Wumpus.new
		addActionsToTile(row, col, "W")
	end

	# adds actions to tile based on wampus and pits position
	def addActionsToTile(row, col, type)
		# check for top tile
		if row > 0
			if type == "P"
				@maze[row - 1][col].SetAction("You feel a breeze...\n")
			else 
				@maze[row - 1][col].SetAction("You smell a stench...\n")
			end	
		end
		# check for bottom tile
		if row < 3
			if type == "P"
				@maze[row + 1][col].SetAction("You feel a breeze...\n")
			else 
				@maze[row + 1][col].SetAction("You smell a stench...\n")
			end	
		end
		# check for left tile
		if col > 0
			if type == "P"
				@maze[row][col - 1].SetAction("You feel a breeze...\n")
			else 
				@maze[row][col - 1].SetAction("You smell a stench...\n")
			end	
		end
		# check for right tile
		if col < 5
			if type == "P"
				@maze[row][col + 1].SetAction("You feel a breeze...\n")
			else 
				@maze[row][col + 1].SetAction("You smell a stench...\n")
			end	
		end
	end

	def doStuff
		choice = "O"
		while choice != "q"
			printMaze
			puts ""
			puts "What do you want to do:"
			puts " u) Move Up"
			puts " d) Move Down"
			puts " l) Move Left"
			puts " r) Move Right"
			puts " s) Shoot Arrow"
			puts " q) Quit"
			print "ENTER CHOICE: "
			choice = gets.chomp #.chomp removes the newline from the input
			if choice == "s"
				puts "What direction do you want to shoot your arrow:"
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
				playerMove(choice)
				printMap
			elsif choice == "d"
				# move character down
				playerMove(choice)
				printMap
			elsif choice == "l"
				# move character left
				playerMove(choice)
				printMap
			elsif choice == "r"
				# move character right
				playerMove(choice)
				printMap
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
c.printMap
c.initMaze
c.doStuff #call the method doStuff of object c

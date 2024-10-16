#PROGRAMMERS: Joao Engel, Brendon Amino, Teran Upchurch
#DATE: 10/09/24
#FILE: wumpus.rb

# A text-based game where players navigate a 6x4 maze to hunt the Wumpus.
# Players can move or shoot to defeat the Wumpus while avoiding deadly pits.
# Sensory cues indicate nearby dangers, and the game features random placement
# of the Wumpus and pits for varied experiences.


# Base class Tile represents a generic tile in the maze, storing sensory queue for nearby dangers
class Tile
    attr_accessor :sensoryQueue
 
    # Initializes an empty sensoryQueue string
    def initialize
        @sensoryQueue = ""
    end
  
    # Sets the sensoryQueue with the provided action string
    def setSensoryQueue(action)
        @sensoryQueue = action
    end
 
    # Retrieves the sensoryQueue
    def getSensoryQueue
        @sensoryQueue
    end

    def visit #By default returns newline, used to print tile specific messages
        puts ""
    end
 end
 
 
 # Derived class Location (formerly EmptyTile) represents an empty tile in the maze
 class Location < Tile
    def type #In place of "print"
        "O"  # Denotes empty tile type
    end
 end
 
 
 # Derived class Pit represents a pit in the maze
 class Pit < Tile
    def visit #Override
        puts "You've fallen into a pit and have perished!"
    end
    
    def type
        "P"  # Denotes pit tile type
    end
 end
 

 # Derived class Wumpus represents the Wumpus in the maze
 class Wumpus < Tile
    def visit #Override
        puts "You've been eaten by the WUMPUS!"
    end

    def type
        "W"  # Denotes Wumpus tile type
    end
 end
 
 
 # The Game class manages the game board and player's actions
 class Game
    attr_accessor :maze, :playerRow, :playerCol

    # Initializes a 6x4 empty maze and sets the player start position
    def initialize()
        @maze = [
        [Location.new, Location.new, Location.new, Location.new, Location.new, Location.new],
        [Location.new, Location.new, Location.new, Location.new, Location.new, Location.new],
        [Location.new, Location.new, Location.new, Location.new, Location.new, Location.new],
        [Location.new, Location.new, Location.new, Location.new, Location.new, Location.new]
        ]
        @playerRow = 3  # Player starts at the bottom left
        @playerCol = 0
    end

    # Randomly places four pits and the Wumpus in the maze
    def initMaze
        # Place four pits (one per row, randomly in columns 1-5)
        for r in 0..3
            col = rand(1..5)
            @maze[r][col] = Pit.new
            addActionsToTile(r, col, "P")  # Adds sensory cues for nearby pits
        end
 
        # Place the Wumpus in a random tile, avoiding pits
        row = rand(0..3)
        col = rand(1..5)
        while @maze[row][col].type == "P"
            row = rand(0..3)
            col = rand(1..5)
        end
        @maze[row][col] = Wumpus.new
        addActionsToTile(row, col, "W")  # Adds sensory cues for nearby Wumpus
    end

    # Prints the maze showing each tile type (P = Pit, W = Wumpus, O = Empty)
    def printMaze
        for r in 0..3 do
            for c in 0..5 do
                print "#{@maze[r][c].type} "
            end
            @maze[3][0].visit #Player starting location: always considered empty tile and will thus return newline
        end
    end
 
    # Prints the player's current map, showing "X" for the player's position
    def printMap
        for r in 0..3 do
            for c in 0..5 do
                if r == @playerRow and c == @playerCol
                    print "X "  # Player position
                else
                    print "O "  # Empty tile
                end
            end
            puts ""
        end
    end
 
    # Moves the player based on input (u = up, d = down, l = left, r = right)
    def playerMove(letter)
        if letter == 'u' and @playerRow > 0
            @playerRow -= 1  # Move up
        elsif letter == 'd' and @playerRow < 3
            @playerRow += 1  # Move down
        elsif letter == 'l' and @playerCol > 0
            @playerCol -= 1  # Move left
        elsif letter == 'r' and @playerCol < 5
            @playerCol += 1  # Move right
        elsif letter == 'q'
            print ""
        else
            print "Ouch! You ran into a wall\n"  # Collision with wall
        end
        checkMove
    end
 
    # Checks the current tile for hazards (Wumpus or Pit) after each move
    def checkMove
        playerCurrentPos = @maze[@playerRow][@playerCol]
        if playerCurrentPos.type == "W" #Checks for Wumpus, then calls Wumpus tile's visit method
            playerCurrentPos.visit
            printMaze
            exit(0)  # End game
        elsif playerCurrentPos.type == "P" #Checks for Pit, then calls Pit tile's visit method
            playerCurrentPos.visit
            printMaze
            exit(0)  # End game
        end
 
        # Provide sensory feedback about nearby dangers
        print "#{playerCurrentPos.getSensoryQueue}"
    end
 
    # Shoots an arrow in the specified direction to try to slay the Wumpus
    def playerShoot(choice)
        if choice == 'u' and @playerRow > 0 and @maze[@playerRow - 1][@playerCol].type == "W"
            puts "\nYou slayed the WUMPUS! You win!"
        elsif choice == 'd' and @playerRow < 3 and @maze[@playerRow + 1][@playerCol].type == "W"
            puts "\nYou slayed the WUMPUS! You win!"
        elsif choice == 'l' and @playerCol > 0 and @maze[@playerRow][@playerCol - 1].type == "W"
            puts "\nYou slayed the WUMPUS! You win!"
        elsif choice == 'r' and @playerCol < 5 and @maze[@playerRow][@playerCol + 1].type == "W"
            puts "\nYou slayed the WUMPUS! You win!"
        else
            puts "\nYou missed and failed to slay the WUMPUS!\n"
        end
        printMaze
        exit(0)
    end
 
    # Adds sensory cues ("breeze" for pits, "stench" for Wumpus) to adjacent tiles
    def addActionsToTile(row, col, type)
        action_text = type == "P" ? "You feel a breeze...\n" : "You smell a stench...\n"
      
        # Add sensory cues to adjacent tiles (up, down, left, right)
        if row > 0 and @maze[row - 1][col].type == "O"
            @maze[row - 1][col].setSensoryQueue(@maze[row - 1][col].getSensoryQueue + action_text)
        end
        if row < 3 and @maze[row + 1][col].type == "O"
            @maze[row + 1][col].setSensoryQueue(@maze[row + 1][col].getSensoryQueue + action_text)
        end
        if col > 0 and @maze[row][col - 1].type == "O"
            @maze[row][col - 1].setSensoryQueue(@maze[row][col - 1].getSensoryQueue + action_text)
        end
        if col < 5 and @maze[row][col + 1].type == "O"
            @maze[row][col + 1].setSensoryQueue(@maze[row][col + 1].getSensoryQueue + action_text)
        end
    end
 
    # Main game loop where players can move, shoot, or quit
    def play
        choice = "O"
        checkMove # letting player know if it is next to a pit or wumpus before first move
        while choice != "q"
            puts ""
            puts "What do you want to do:"
            puts " u) Move Up"
            puts " d) Move Down"
            puts " l) Move Left"
            puts " r) Move Right"
            puts " s) Shoot Arrow"
            puts " q) Quit"
            print "ENTER CHOICE: "
            choice = gets.chomp
            puts ""

            if choice == "q" #If player quits, prints quitting game and doesn't print anything else
                puts "Quitting game..."
                #printMaze
                break
            end
            if choice != "s" and choice != "u" and choice != "d" and choice != "l" and choice != "r" and choice != "q"
                puts "Invalid choice!"
                printMap
            elsif choice == "s"
                puts "What direction do you want to shoot your arrow:"
                puts " u) Shoot Up"
                puts " d) Shoot Down"
                puts " l) Shoot Left"
                puts " r) Shoot Right"
                print "ENTER CHOICE: "
                shotDirection = gets.chomp
 
                #If shot direction isn't a valid letter,
            if shotDirection != "u" and shotDirection != "d" and shotDirection != "l" and shotDirection != "r"
                puts ""
                puts "Invalid choice!"
                printMap
            else
                playerShoot(shotDirection)
            end
            else
                playerMove(choice)
                printMap  # Print the player's map showing position after move
            end
        end
    end
 end


 # main program execution
 c = Game.new #create a new Game object called c
 c.printMap
 c.initMaze
 c.play  # starts the game menu
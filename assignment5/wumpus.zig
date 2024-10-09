//PROGRAMMERS: Joao Engel, Teran Upchurch, Brendon Amino
//DATE: 10/08/24
//FILE: wumpus.zig
//
// Hunt the Wumpus Game
//
// A text-based game where players navigate a 6x4 maze to hunt the Wumpus.
// Players can move or shoot to defeat the Wumpus while avoiding deadly pits.
// Sensory cues indicate nearby dangers, and the game features random placement
// of the Wumpus and pits for varied experiences.


const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;


// Define a 4x6 maze where each cell starts as an 'O' (open space)
var maze = [4][6]u8{
   .{ 'O', 'O', 'O', 'O', 'O', 'O' },
   .{ 'O', 'O', 'O', 'O', 'O', 'O' },
   .{ 'O', 'O', 'O', 'O', 'O', 'O' },
   .{ 'O', 'O', 'O', 'O', 'O', 'O' },
};


// Player's initial position
var playerRow: usize = 3;
var playerCol: usize = 0;


// Function to print the contents of the maze
fn printMaze() void {
   for (0..4) |i| {
       print("{s}\n", .{maze[i]});
   }
}


// Prints the map and player's current location on it with an 'X'
fn printMap(curPlayerRow: usize, curPlayerCol: usize) void {
   for (0..4) |r| {
       for (0..6) |c| {
           if (r == curPlayerRow and c == curPlayerCol) {
               print("X", .{}); // Player's current position
           } else {
               print("O", .{}); // Open space
           }
       }
       print("\n", .{}); // Move to the next line after each row
   }
}


// Initialize the maze by randomly placing pits and a wumpus
fn initMaze() void {
   const rand = std.crypto.random; // Random number generator
   var col: usize = 0;
   var row: usize = 0;


   // Place four pits (one per row)
   for (0..4) |r| {
       col = rand.intRangeAtMost(u8, 1, 5); // Random column for pit
       maze[r][col] = 'P'; // Place pit
   }


   // Place the wumpus
   col = rand.intRangeAtMost(u8, 1, 5); // Random column for wumpus
   row = rand.intRangeAtMost(u8, 0, 3); // Random row for wumpus
   while (maze[row][col] == 'P') { // Ensure wumpus is not placed in a pit
       col = rand.intRangeAtMost(u8, 1, 5);
       row = rand.intRangeAtMost(u8, 0, 3);
   }


   maze[row][col] = 'W'; // Place wumpus
}


// Function to move the player based on input
fn characterMove(playerMove: u8, curPlayerRow: usize, curPlayerCol: usize) void {
   if (playerMove == 'u' and playerRow > 0 and checkWall(curPlayerRow - 1, curPlayerCol)) {
       playerRow -= 1; // Move up
       checkMove(playerRow, playerCol); // Check new position
   } else if (playerMove == 'd' and checkWall(curPlayerRow + 1, curPlayerCol)) {
       playerRow += 1; // Move down
       checkMove(playerRow, playerCol);
   } else if (playerMove == 'l' and playerCol > 0 and checkWall(curPlayerRow, curPlayerCol - 1)) {
       playerCol -= 1; // Move left
       checkMove(playerRow, playerCol);
   } else if (playerMove == 'r' and checkWall(curPlayerRow, curPlayerCol + 1)) {
       playerCol += 1; // Move right
       checkMove(playerRow, playerCol);
   } else {
       print("\nOuch! You ran into a wall\n", .{}); // Collision with wall
   }
}


// Check if the new position is within maze boundaries
fn checkWall(newPlayerRow: usize, newPlayerCol: usize) bool {
   if ((newPlayerRow > 3) or (newPlayerRow < 0) or (newPlayerCol > 5) or (newPlayerCol < 0)) {
       return false; // Out of bounds, invalid move
   }
   return true; // Valid move
}


// Check for wumpus or pit in the player's current position
fn checkMove(newRow: usize, newCol: usize) void {
   // Check if the player found the wumpus
   if (maze[newRow][newCol] == 'W') {
       print("\nYou've been eaten by the WUMPUS!\n", .{});
       printMaze(); // Show the maze before exiting
       std.process.exit(0); // Exit the game
   }
   // Check if the player fell into a pit
   else if (maze[newRow][newCol] == 'P') {
       print("\nYou've fallen into a pit and have perished!\n", .{});
       printMaze(); // Show the maze before exiting
       std.process.exit(0); // Exit the game
   }


   // Check for proximity to pits or wumpus for warning messages
   // Check the cell above
   if (newRow > 0 and maze[newRow - 1][newCol] != 'O') {
       if (maze[newRow - 1][newCol] == 'P') {
           print("You feel a breeze...\n", .{}); // Nearby pit
       } else {
           print("You smell a stench...\n", .{}); // Nearby wumpus
       }
   }
   // Check the cell below
   if (newRow < 3 and maze[newRow + 1][newCol] != 'O') {
       if (maze[newRow + 1][newCol] == 'P') {
           print("You feel a breeze...\n", .{}); // Nearby pit
       } else {
           print("You smell a stench...\n", .{}); // Nearby wumpus
       }
   }
   // Check the cell to the right
   if (newCol < 5 and maze[newRow][newCol + 1] != 'O') {
       if (maze[newRow][newCol + 1] == 'P') {
           print("You feel a breeze...\n", .{}); // Nearby pit
       } else {
           print("You smell a stench...\n", .{}); // Nearby wumpus
       }
   }
   // Check the cell to the left
   if (newCol > 0 and maze[newRow][newCol - 1] != 'O') {
       if (maze[newRow][newCol - 1] == 'P') {
           print("You feel a breeze...\n", .{}); // Nearby pit
       } else {
           print("You smell a stench...\n", .{}); // Nearby wumpus
       }
   }
}


// Check if the wumpus is in the adjacent space in the direction the player is shooting
fn checkShoot(dir: u8, curPlayerRow: usize, curPlayerCol: usize) bool {
   if (dir == 'u') {
       if (curPlayerRow != 0 and maze[curPlayerRow - 1][curPlayerCol] == 'W') {
           return true; // Wumpus is above
       }
   } else if (dir == 'r') {
       if (curPlayerCol != 5 and maze[curPlayerRow][curPlayerCol + 1] == 'W') {
           return true; // Wumpus is to the right
       }
   } else if (dir == 'd') {
       if (curPlayerRow != 3 and maze[curPlayerRow + 1][curPlayerCol] == 'W') {
           return true; // Wumpus is below
       }
   } else if (dir == 'l') {
       if (curPlayerCol != 0 and maze[curPlayerRow][curPlayerCol - 1] == 'W') {
           return true; // Wumpus is to the left
       }
   }
   return false; // Wumpus is not in the shooting direction
}


// Main game function
pub fn main() !void {
   const reader = std.io.getStdIn().reader(); // Standard input reader
   var buffer: [16]u8 = undefined; // Buffer for user input
   var choice: u8 = '1'; // User's action choice
   var shotChoice: u8 = '1'; // Direction to shoot


   initMaze(); // Initialize maze with pits and wumpus
   printMap(playerRow, playerCol); // Display initial player position
   checkMove(playerRow, playerCol); // Check initial surroundings


   // Game loop
   while (choice != 'q') {
       // Display options to the player
       print("What do you want to do:\n u) move up\n", .{});
       print(" d) move down\n l) move left\n r) move right\n s) shoot arrow\n q) quit\n ENTER CHOICE: ", .{});
       const input = try reader.readUntilDelimiter(&buffer, '\n');
       choice = input[0]; // Get user choice
       if (choice == 's') {
           print("\nWhat direction do you want to shoot your arrow:\n", .{});
           print(" u) up\n d) down\n l) left\n r) right\n ENTER CHOICE: ", .{});
           const direction = try reader.readUntilDelimiter(&buffer, '\n');
           shotChoice = direction[0]; // Get shooting direction
           // Validate shooting direction
           if (shotChoice != 'u' and shotChoice != 'd' and shotChoice != 'l' and shotChoice != 'r') {
               print("\nInvalid choice\n\n", .{});
               printMap(playerRow, playerCol);
               continue;
           }
           // Check if shot hit the wumpus
           if (!checkShoot(shotChoice, playerRow, playerCol)) {
               print("You missed and failed to slay the WUMPUS!\n", .{});
           } else {
               print("You slayed the WUMPUS! You win!\n", .{});
           }
           printMaze(); // Show the maze after shooting
           break; // End the game after shooting
       } else if (choice == 'u') {
           characterMove(choice, playerRow, playerCol); // Move up
           printMap(playerRow, playerCol);
       } else if (choice == 'd') {
           characterMove(choice, playerRow, playerCol); // Move down
           printMap(playerRow, playerCol);
       } else if (choice == 'l') {
           characterMove(choice, playerRow, playerCol); // Move left
           printMap(playerRow, playerCol);
       } else if (choice == 'r') {
           characterMove(choice, playerRow, playerCol); // Move right
           printMap(playerRow, playerCol);
       } else if (choice != 'q') {
           print("\nInvalid choice\n\n", .{}); // Handle invalid choices
       }
   }
}

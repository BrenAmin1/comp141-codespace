//PROGRAMMER: Dan Cliburn
//DATE: 8/22/24
//FILE: test.zig
//This file provides a short example of how to code in Zig

// TODO: check with professor, double print message when close to 2 pits and also if breeze and stench should be printed at the start of the game if near to a pit or wumpus

const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

var maze = [4][6]u8{
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
};

var playerRow: usize = 3;
var playerCol: usize = 0;

//function to print the contents of the maze
fn printMaze() void {
    for (0..4) |i| {
        print("{s}\n", .{maze[i]});
    }
}

//prints the player's current location on the map with an X
fn printMap(curPlayerRow: usize, curPlayerCol: usize) void {
    for (0..4) |r| {
        for (0..6) |c| {
            if (r == curPlayerRow and c == curPlayerCol) {
                print("X", .{});
            } else {
                print("O", .{});
            }
        }
        print("\n", .{});
    }
}

fn initMaze() void {
    const rand = std.crypto.random;
    var col: usize = 0;
    var row: usize = 0;

    // place four pits (one per row)
    for (0..4) |r| {
        col = rand.intRangeAtMost(u8, 1, 5);
        maze[r][col] = 'P';
    }

    // place the wumps
    col = rand.intRangeAtMost(u8, 1, 5);
    row = rand.intRangeAtMost(u8, 0, 3);
    while (maze[row][col] == 'P') {
        col = rand.intRangeAtMost(u8, 1, 5);
        row = rand.intRangeAtMost(u8, 0, 3);
    }

    maze[row][col] = 'W';
}

fn characterMove(playerMove: u8, curPlayerRow: usize, curPlayerCol: usize) void {
    if (playerMove == 'u' and playerRow > 0 and checkWall(curPlayerRow - 1, curPlayerCol)) {
        playerRow -= 1;
        checkMove(playerRow, playerCol);
        //print("up\n", .{});
    } else if (playerMove == 'd' and checkWall(curPlayerRow + 1, curPlayerCol)) {
        playerRow += 1;
        checkMove(playerRow, playerCol);
        //print("down\n", .{});
    } else if (playerMove == 'l' and playerCol > 0 and checkWall(curPlayerRow, curPlayerCol - 1)) {
        playerCol -= 1;
        checkMove(playerRow, playerCol);
        //print("left\n", .{});
    } else if (playerMove == 'r' and checkWall(curPlayerRow, curPlayerCol + 1)) {
        playerCol += 1;
        checkMove(playerRow, playerCol);
        //print("right\n", .{});
    } else {
        print("\nOuch! You ran into a wall\n", .{});
    }
}

//If input is greater than MAXROWSIZE/MAXCOLSIZE or less than MINROWSIZE/MINCOLSIZE return false?
fn checkWall(newPlayerRow: usize, newPlayerCol: usize) bool {
    if ((newPlayerRow > 3) or (newPlayerRow < 0) or (newPlayerCol > 5) or (newPlayerCol < 0)) {
        //print("Ouch! You ran into a wall\n", .{});
        return false;
    }
    return true;
}

// After every move checkMove is called which checks if the player is next to or in a pit or wumpus
// prints a statement if any of these are true
fn checkMove(newRow: usize, newCol: usize) void {
    //check to see if user finds the wumpus
    if (maze[newRow][newCol] == 'W') {
        print("\nYou've been eaten by the WUMPUS!\n", .{});
        printMaze();
        std.process.exit(0);
        //return false; // maybe will need to return something else
    }
    // checks to see if user fell in a pit
    else if (maze[newRow][newCol] == 'P') {
        // print appropriate message for player falling in a pit and terminate the program
        print("\nYou've fallen into a pit and have perished!\n", .{});
        printMaze();
        std.process.exit(0);
        //return false; // maybe will need to return something else
    }

    // check if user is near a pit or the wumpus
    // checking for above
    if (newRow > 0 and maze[newRow - 1][newCol] != 'O') {
        if (maze[newRow - 1][newCol] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            print("You smell a stench...\n", .{});
            // print message for stench
        }
        //return true; // maybe will need to return something else
    }
    // checking for other for below
    if (newRow < 3 and maze[newRow + 1][newCol] != 'O') {
        if (maze[newRow + 1][newCol] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            // print message for stench
            print("You smell a stench...\n", .{});
        }
        //return true;
    }
    // checking for other for right
    if (newCol < 5 and maze[newRow][newCol + 1] != 'O') {
        if (maze[newRow][newCol + 1] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            // print message for stench
            print("You smell a stench...\n", .{});
        }
        //return true;
    }
    // checking for other for left
    if (newCol > 0 and maze[newRow][newCol - 1] != 'O') {
        if (maze[newRow][newCol - 1] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            // print message for stench
            print("You smell a stench...\n", .{});
        }
        //return true;
    }
}

// When player chooses to shoot arrow, checkShoot detersmines which side of player to check if the wumpus is there
// and returns true if it is and false if not
fn checkShoot(dir: u8, curPlayerRow: usize, curPlayerCol: usize) bool {
    if (dir == 'u') {
        if (curPlayerRow != 0 and maze[curPlayerRow - 1][curPlayerCol] == 'W') {
            return true;
        }
    } else if (dir == 'r') {
        if (curPlayerCol != 5 and maze[curPlayerRow][curPlayerCol + 1] == 'W') {
            return true;
        }
    } else if (dir == 'd') {
        if (curPlayerRow != 3 and maze[curPlayerRow + 1][curPlayerCol] == 'W') {
            return true;
        }
    } else if (dir == 'l') {
        if (curPlayerCol != 0 and maze[curPlayerRow][curPlayerCol - 1] == 'W') {
            return true;
        }
    }
    return false;
}

pub fn main() !void {
    const reader = std.io.getStdIn().reader();
    var buffer: [16]u8 = undefined; //creates a buffer to hold 16 characters
    var choice: u8 = '1';
    var shotChoice: u8 = '1';

    initMaze();
    printMap(playerRow, playerCol);
    //printMaze();
    checkMove(playerRow, playerCol);

    while (choice != 'q') {
        print("What do you want to do:\n u) move up\n", .{});
        print(" d) move down\n l) move left\n r) move right\n s) shoot arrow\n q) quit\n ENTER CHOICE: ", .{});
        const input = try reader.readUntilDelimiter(&buffer, '\n');
        choice = input[0];
        if (choice == 's') {
            print("\nWhat direction do you want to shoot your arrow:\n", .{});
            print(" u) up\n d) down\n l) left\n r) right\n ENTER CHOICE: ", .{});
            const direction = try reader.readUntilDelimiter(&buffer, '\n');
            shotChoice = direction[0];
            if (shotChoice != 'u' and shotChoice != 'd' and shotChoice != 'l' and shotChoice != 'r') {
                print("\nInvalid choice\n\n", .{});
                printMap(playerRow, playerCol);
                continue;
            }
            if (!checkShoot(shotChoice, playerRow, playerCol)) {
                print("You missed and failed to slay the WUMPUS!\n", .{});
            } else {
                print("You slayed the WUMPUS! You win!\n", .{});
            }
            // printing maze because after shooting, the game is done no matter what
            printMaze();
            break;
            // terminate game gracefully
        } else if (choice == 'u') {
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice == 'd') {
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice == 'l') {
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice == 'r') {
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice != 'q') {
            print("\nInvalid choice\n\n", .{});
        }
    }
}

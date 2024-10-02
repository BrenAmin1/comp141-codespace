//PROGRAMMER: Dan Cliburn
//DATE: 8/22/24
//FILE: test.zig
//This file provides a short example of how to code in Zig

const std = @import("std");
const print = std.debug.print;
const expect = std.testing.expect;

var maze = [4][6]u8{
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
};

//function to print the contents of the array
fn printMaze() void {
    for (0..4) |i| {
        print("{s}\n", .{maze[i]});
    }
}

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
    if (playerMove == 'u' and checkWall(curPlayerRow + 1, curPlayerCol)) {
        playerRow += 1;
        checkMove(playerRow, playerCol);
        print("up\n", .{});
    }
    if (playerMove == 'd' and curPlayerRow != 0) {
        if (checkWall(curPlayerRow - 1, curPlayerCol)) {
            playerRow -= 1;
            checkMove(playerRow, playerCol);
            print("down\n", .{});
        }
    } else {
        print("Ouch! You ran into a wall\n", .{});
    }
    if (playerMove == 'l' and curPlayerCol != 0) {
        if (checkWall(curPlayerRow, curPlayerCol - 1)) {
            playerCol -= 1;
            checkMove(playerRow, playerCol);
            print("left\n", .{});
        }
    } else {
        return;
    }
    if (playerMove == 'r' and checkWall(curPlayerRow, curPlayerCol + 1)) {
        playerCol += 1;
        checkMove(playerRow, playerCol);
        print("right\n", .{});
    }
}

test "moveChar" {
    if (characterMove('d', 0, 2) == true) {
        print("test", .{});
    }
}

//If input is greater than MAXROWSIZE/MAXCOLSIZE or less than MINROWSIZE/MINCOLSIZE return false?
fn checkWall(newPlayerRow: usize, newPlayerCol: usize) bool {
    if ((newPlayerRow > 3) or (newPlayerRow < 0) or (newPlayerCol > 5) or (newPlayerCol < 0)) {
        print("Ouch! You ran into a wall\n", .{});
        return false;
    }
    return true;
}

fn checkArrowHitWall(newPlayerRow: usize, newPlayerCol: usize) bool {
    if ((newPlayerRow > 3) or (newPlayerRow < 0) or (newPlayerCol > 5) or (newPlayerCol < 0)) {
        return false;
    }
    return true;
}

test "check wall" {
    if (checkWall(1, 2) == true) {
        print("test", .{});
    }
}

fn checkMove(newRow: usize, newCol: usize) void {
    //check to see if user finds the wumpus
    if (maze[newRow][newCol] == 'W') {
        // print appropriate message for player beeing eaten an terminate the program
        print("You've been eaten by the WUMPUS!\n", .{});
        //return false; // maybe will need to return something else
    }
    // checks to see if user fell in a pit
    else if (maze[newRow][newCol] == 'P') {
        // print appropriate message for player falling in a pit and terminate the program
        print("You've fallen into a pit and have perished!\n", .{});
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
    if (newRow < 3 and maze[newRow][newCol + 1] != 'O') {
        if (maze[newRow + 1][newCol] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            // print message for stench
            print("You smell a stench...\n", .{});
        }
        //return true;
    }
    // checking for other for left
    if (newRow < 3 and maze[newRow][newCol - 1] != 'O') {
        if (maze[newRow + 1][newCol] == 'P') {
            // print message for breeze
            print("You feel a breeze...\n", .{});
        } else {
            // print message for stench
            print("You smell a stench...\n", .{});
        }
        //return true;
    }
}

fn checkShoot(dir: u8, curPlayerRow: usize, curPlayerCol: usize) bool {
    if (dir == 'u') {
        if (checkArrowHitWall(curPlayerRow + 1, curPlayerCol)) {
            if (maze[curPlayerRow + 1][curPlayerCol] == 'w') {
                return true;
            }
        }
    } else if (dir == 'r') {
        if (checkArrowHitWall(curPlayerRow, curPlayerCol + 1)) {
            if (maze[curPlayerRow][curPlayerCol + 1] == 'w') {
                return true;
            }
        }
    } else if (dir == 'd') {
        if (curPlayerRow == 0) {
            return false;
        } else {
            if (checkArrowHitWall(curPlayerRow - 1, curPlayerCol)) {
                if (maze[curPlayerRow - 1][curPlayerCol] == 'd') {
                    return true;
                }
            }
        }
    } else if (dir == 'l') {
        if (curPlayerCol == 0) {
            return false;
        } else {
            if (checkArrowHitWall(curPlayerRow, curPlayerCol - 1)) {
                if (maze[curPlayerRow][curPlayerCol - 1] == 'w') {
                    return true;
                }
            }
        }
    }
    return false;
}

var playerRow: usize = 3; // TODO: change to var once we create function that moves player arond
var playerCol: usize = 0; // TODO: change to var once we create function that moves player arond

pub fn main() !void {
    const reader = std.io.getStdIn().reader();
    var buffer: [16]u8 = undefined; //creates a buffer to hold 16 characters
    var choice: u8 = '1';
    var shotChoice: u8 = '1';

    initMaze();
    //printMaze();
    printMap(playerRow, playerCol);

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
            if (shotChoice != 'u' or shotChoice != 'd' or shotChoice != 'l' or shotChoice != 'r') {
                print("\nInvalid choice\n\n", .{});
            }
            if (!checkShoot(shotChoice, playerRow, playerCol)) {
                print("You missed and failed to slay the WUMPUS!\n", .{});
                break;
            } else {
                print("You slayed the WUMPUS! You win!\n", .{});
            }
            // add function call to know if you killed monster
            // printing maze because after shooting, the game is done no matter what
            printMaze();
            // terminate game gracefully
        } else if (choice == 'u') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice == 'd') {
            // need to update the player pos before calling the print map
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice == 'l') {
            // need to update the player pos before calling the print map
            characterMove(choice, playerRow, playerCol);
            printMap(playerRow, playerCol);
        } else if (choice == 'r') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice != 'q') {
            print("\nInvalid choice\n\n", .{});
        }
    }
}

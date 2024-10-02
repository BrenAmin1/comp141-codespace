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

//function to count the occurences of letter in maze
fn countIn2Darray(letter: u8) c_int {
    var total: c_int = 0;

    for (0..3) |r| {
        for (0..3) |c| {
            if (maze[r][c] == letter) {
                total += 1;
            }
        }
    }
    return total;
}

//function that returns a random character in maze
fn randomCharIn2Darray() u8 {
    const rand = std.crypto.random;

    const col: usize = rand.intRangeAtMost(u8, 0, 5);
    const row: usize = rand.intRangeAtMost(u8, 0, 3);

    return maze[row][col];
}

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

fn characterMove(playerMove: u8, curPlayerRow: usize, curPlayerCol: usize) bool {
    if (playerMove == 'u' and checkWall(curPlayerRow + 1, curPlayerCol)) {
        playerRow += 1;
        checkMove(playerRow, playerCol);
        print("up\n", .{});
    }
    if (playerMove == 'd' and checkWall(curPlayerRow - 1, curPlayerCol)) {
        playerRow -= 1;
        print("down\n", .{});
    }
    if (playerMove == 'l' and checkWall(curPlayerRow, curPlayerCol - 1)) {
        playerCol -= 1;
        print("left\n", .{});
    }
    if (playerMove == 'r' and checkWall(curPlayerRow, curPlayerCol + 1)) {
        playerCol += 1;
        print("right\n", .{});
    }
    return true;
}

test "moveChar" {
    if (characterMove('u', 1, 2) == true) {
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

// pub fn checkWall(dir: u8, row: usize, col: usize) bool {
//     if ((dir == 'u' and row < 1) or (dir == 'l' and col < 1) or (dir == 'd' and row == 3) or (dir == 'r' and col == 5)) {
//         print("Ouch! You ran into a wall", .{});
//         return true;
//     }
//     return false;
// }

test "check wall" {
    if (checkWall(1, 2) == true) {
        print("test", .{});
    }
}

fn checkMove(newRow: usize, newCol: usize) bool {
    //check to see if user finds the wumpus
    if (maze[newRow][newCol] == 'w') {
        // print appropriate message for player beeing eaten an terminate the program
        return false; // maybe will need to return something else
    }
    // checks to see if user fell in a pit
    else if (maze[newRow][newCol] == 'p') {
        // print appropriate message for player falling in a pit and terminate the program
        return false; // maybe will need to return something else
    }

    // check if user is near a pit or the wumpus
    // checking for above
    if (newRow > 0 and maze[newRow - 1][newCol] != 'O') {
        if (maze[newRow - 1][newCol] == 'P') {
            // print message for breeze
        }
        else{
            // print message for stench
        }
        return 1;
    }
    // checking for other sides ...
}

var playerRow: usize = 3; // TODO: change to var once we create function that moves player arond
var playerCol: usize = 0; // TODO: change to var once we create function that moves player arond

pub fn main() !void {
    const reader = std.io.getStdIn().reader();
    var buffer: [16]u8 = undefined; //creates a buffer to hold 16 characters
    var choice: u8 = '1';
    var shotChoice: u8 = '1';

    initMaze();
    printMaze();
    printMap(playerRow, playerCol);

    while (choice != 'q') {
        print("What do you want to do:\n u) move up\n", .{});
        print(" d) move down\n l) move left\n r) move right\n s) shoot arrow\n q) quit\n ENTER CHOICE: ", .{});
        const input = try reader.readUntilDelimiter(&buffer, '\n');
        choice = input[0];
        if (choice == 's') {
            print("\nWhat direction do you want to shoot your arrow:\n ", .{});
            print("u) up\n d) down\n l) left\n r) right\n ENTER CHOICE: ", .{});
            const direction = try reader.readUntilDelimiter(&buffer, '\n');
            shotChoice = direction[0];
            // add function call to know if you killed monster
            // printing maze because after shooting, the game is done no matter what
            printMaze();
            // terminate game gracefully
        } else if (choice == 'u') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice == 'd') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice == 'l') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice == 'r') {
            // need to update the player pos before calling the print map
            printMap(playerRow, playerCol);
        } else if (choice != 'q') {
            print("\nInvalid choice\n", .{});
        }
    }
}

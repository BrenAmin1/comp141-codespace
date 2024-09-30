//PROGRAMMER: Dan Cliburn
//DATE: 8/22/24
//FILE: test.zig
//This file provides a short example of how to code in Zig

const std = @import("std");
const print = std.debug.print;

var maze = [4][6]u8{
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
    .{ 'O', 'O', 'O', 'O', 'O', 'O' },
};

//function to count the occurences of letter in maze
pub fn countIn2Darray(letter: u8) c_int {
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
pub fn randomCharIn2Darray() u8 {
    const rand = std.crypto.random;

    const col: usize = rand.intRangeAtMost(u8, 0, 5);
    const row: usize = rand.intRangeAtMost(u8, 0, 3);

    return maze[row][col];
}

//function to print the contents of the array
pub fn printMaze() void {
    for (0..4) |i| {
        print("{s}\n", .{maze[i]});
    }
}
//
pub fn printMap(playerRow: usize, playerCol: usize) void {
    for (0..4) |r| {
        for (0..6) |c| {
            if (r == playerRow and c == playerCol) {
                print("X", .{});
            } else {
                print("O", .{});
            }
        }
        print("\n", .{});
    }
}

pub fn initMaze() void {
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

pub fn main() !void {
    const reader = std.io.getStdIn().reader();
    var buffer: [16]u8 = undefined; //creates a buffer to hold 16 characters
    var choice: u8 = '1';

    const playerRow: usize = 3; // TODO: change to var once we create function that moves player arond
    const playerCol: usize = 0; // TODO: change to var once we create function that moves player arond

    initMaze();
    printMaze();
    printMap(playerRow, playerCol);

    while (choice != '4') {
        print("What do you want to do:\n 1) count occurrences of a letter in array\n", .{});
        print(" 2) return a random letter in array\n 3) print array\n 4) quit\nENTER CHOICE: ", .{});
        const input = try reader.readUntilDelimiter(&buffer, '\n');
        choice = input[0];
        if (choice == '1') {
            print("\nWhat letter do you want to search for: ", .{});
            const letter = try reader.readUntilDelimiter(&buffer, '\n');
            print("\n{}\n", .{countIn2Darray(letter[0])});
        } else if (choice == '2') {
            print("\n{c}\n", .{randomCharIn2Darray()});
        } else if (choice == '3') {
            printMaze();
        } else if (choice != '4') {
            print("\nInvalid choice\n", .{});
        }
    }
}

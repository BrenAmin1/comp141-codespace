const std = @import("std");
const expect = std.testing.expect;

const space = struct {
    isPlayer: bool,
    isHole: bool,
    isWumpus: bool,
    isBreeze: bool,
    isStench: bool,
    currentSpaceChar: u8,

    pub fn init(isPlayer: bool, isHole: bool, isWumpus: bool, isBreeze: bool, isStench: bool, currentSpaceChar: u8) space {
        return space{
            .isPlayer = isPlayer,
            .isHole = isHole,
            .isWumpus = isWumpus,
            .isBreeze = isBreeze,
            .isStench = isStench,
            .currentSpaceChar = currentSpaceChar,
        };
    }
};
var maze: [4][5]space = undefined;
test "maze" {
    for (0..4) |r| {
        for (0..5) |c| {
            maze[r][c].currentSpaceChar = 'O';
        }
    }
    std.debug.print("var: {u8}\n", .{maze[0][0].currentSpaceChar});
    try expect(maze[0][0].currentSpaceChar == 'O');
}
pub fn main() !void {
    std.debug.print("Hunt down the wumpus and try to shoot it with your arrow!\n", .{});
    var i: usize = 0;
    while (true) {
        i += 1;
        if (i == 10) {
            break;
        }
        std.debug.print("I am dog\n", .{});
    }
}

const std = @import("std");
const tokens = @import("./lexer/tokens.zig");


const expect = @import("std").testing.expect;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const contents = try std.fs.cwd().readFileAlloc(alloc, "examples/00.lang", 4096);
    defer alloc.free(contents);

    std.debug.print("{s}", .{contents});
}

test "token kinds" {
    const test_token = tokens.Token{
        .kind = @intFromEnum(tokens.Tokens.IDENTIFIER),
        .value = "test_value",
    };
    test_token.debug();
}

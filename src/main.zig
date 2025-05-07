const std = @import("std");
const expect = @import("std").testing.expect;
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    const contents = try std.fs.cwd().readFileAlloc(alloc, "examples/00.lang", 4096);
    defer alloc.free(contents);

    std.debug.print("{s}", .{contents});
}

const Tokens = enum(u8) {
    EOF,
    NUMBER,
    STRING,
    IDENTIFIER,

    OPEN_BRACKET,
    CLOSE_BRACKET,
    OPEN_CURLY,
    CLOSE_CURLY,
    OPEN_PAREN,
    CLOSE_PAREN,

    ASSIGNMENT,
    EQUALS,
    NOT,
    NOT_EQUALS,

    LESS,
    LESS_EQUALS,
    GREATER,
    GREATER_EQUALS,

    OR,
    AND,

    DOT,
    SEMI_COLON,
    COLON,
    QUESTION,
    COMMA,

    PLUS_PLUS,
    MINUS_MINUS,
    PLUS_EQUALS,
    MINUS_EQUALS,

    PLUS,
    DASH,
    SLASH,
    STAR,
    PERCENT,

    // reserved keywords
    LET,
    CONST,
};

const Token = struct {
    kind: u8,
    value: []const u8,

    pub fn init(kind: u8, value: []u8) Token {
        return Token{
            .kind = kind,
            .value = value,
        };
    }

    fn is_one_of_many(self: Token, expected_tokens: [3]u8) bool {
        for (expected_tokens) |expected_token| {
            if (expected_token == self.kind) {
                return true;
            }
        }
        return false;
    }

    pub fn debug(self: Token) void {
        const expected_tokens = [_]u8{
            @intFromEnum(Tokens.IDENTIFIER),
            @intFromEnum(Tokens.NUMBER),
            @intFromEnum(Tokens.STRING),
        };
        if (self.is_one_of_many(expected_tokens)) {
            std.debug.print("{s} ({s})\n", .{ TokenKindString(self.kind), self.value });
        } else {
            std.debug.print("{s} ()\n", .{TokenKindString(self.kind)});
        }
    }
};

fn TokenKindString(kind: u8) []const u8 {
    const token_kind_string: []const u8 = switch (kind) {
        @intFromEnum(Tokens.EOF) => "eof",
        @intFromEnum(Tokens.NUMBER) => "number",
        @intFromEnum(Tokens.IDENTIFIER) => "identifier",
        else => "unknown",
    };

    return token_kind_string;
}

test "token kinds" {
    const test_token = Token{
        .kind = @intFromEnum(Tokens.IDENTIFIER),
        .value = "test_value",
    };
    test_token.debug();
}

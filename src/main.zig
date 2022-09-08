const std = @import("std");
const perm_generator = @import("permutation_generator.zig");


pub fn main() anyerror!void {
    var num1: u8 = 5;
    var num1_pointer: *u8 = &num1;

    var num2: u8 = undefined;

    // Please make num2 equal 5 using num1_pointer!
    // (See the "cheatsheet" above for ideas.)
    num2 = num1_pointer.*;

    // Permutations.
    //
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!general_purpose_allocator.deinit());

    const allocator = general_purpose_allocator.allocator();

    // Init might fail. 
    //
    var pg_1 = try perm_generator.PermutationGenerator.init(allocator, 4);
    defer pg_1.deinit();

    var pg_2 = try perm_generator.PermutationGenerator.create(allocator, 4);
    defer pg_2.destroy();

    _ = pg_1;

    _ = pg_2;

    var perm = pg_1.next();
    
    while (perm != null) {
        if (perm != null) {
            std.debug.print("foo={}, {}, {}, {},\n", .{ perm.?[0], perm.?[1], perm.?[2], perm.?[3] });
        }

        perm = pg_1.next();
    }

    const a: u8 = 12;
    const b: *const u8 = &a; // fix this!

    _ = b;

    var foo: u8 = 5;
    var bar: u8 = 10;

    // Please define pointer "p" so that it can point to EITHER foo or
    // bar AND change the value it points to!
    var p: *u8 = undefined;

    p = &foo;
    p.* += 1;
    p = &bar;
    p.* += 1;
    std.debug.print("foo={}, bar={}\n", .{ foo, bar });

    // var x: u8 = 255;
    // x += 1;

    std.log.info("All your codebase are belong to us.", .{});
}

test "basic test" {
    try std.testing.expectEqual(10, 3 + 7);
}

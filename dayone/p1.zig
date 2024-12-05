const std = @import("std");
const loadData = @import("./load-data.zig").loadData;

const ArrayList = std.ArrayList;

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var left = ArrayList(i32).init(alloc);
    var right = ArrayList(i32).init(alloc);

    try loadData(&left, &right);

    const as = left.items;
    const bs = right.items;

    std.mem.sort(i32, as, {}, comptime std.sort.asc(i32));
    std.mem.sort(i32, bs, {}, comptime std.sort.asc(i32));

    var total: u32 = 0;

    for (as, bs) |a, b| {
        total += @abs(a - b);
    }

    std.debug.print("\n\n{d}\n", .{total});
}

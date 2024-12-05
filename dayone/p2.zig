const std = @import("std");
const loadData = @import("./load-data.zig").loadData;

const ArrayList = std.ArrayList;

fn count(right: []i32, value: i32) i32 {
    var c: i32 = 0;
    for (right) |r| {
        if (r == value) {
            c += 1;
        }
    }
    return c;
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;
    var leftList = ArrayList(i32).init(alloc);
    var rightList = ArrayList(i32).init(alloc);

    try loadData(&leftList, &rightList);

    const left = leftList.items;
    const right = rightList.items;

    var total: i32 = 0;

    for (left) |a| {
        const c = count(right, a);
        total += (a * c);
    }

    std.debug.print("\n\n{d}\n", .{total});
}

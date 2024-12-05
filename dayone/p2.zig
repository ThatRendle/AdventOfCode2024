const std = @import("std");
const ArrayList = std.ArrayList;

fn readLine(reader: std.fs.File.Reader, buffer: []u8) !?[]const u8 {
    const line = (try reader.readUntilDelimiterOrEof(
        buffer,
        '\n',
    )) orelse return null;
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, line, "\r");
    } else {
        return line;
    }
}

fn loadData(left: *ArrayList(i32), right: *ArrayList(i32)) !void {
    const cwd = std.fs.cwd();

    const file = try cwd.openFile("data.txt", .{ .mode = .read_only });
    defer file.close();

    const reader = file.reader();

    var buffer: [100]u8 = undefined;

    var line = try readLine(reader, &buffer);
    while (line != null and line.?.len > 0) {
        var it = std.mem.tokenize(u8, line.?, " ");
        const sa = it.next().?;
        const sb = it.next().?;
        const a = try std.fmt.parseInt(i32, sa, 10);
        const b = try std.fmt.parseInt(i32, sb, 10);
        try left.append(a);
        try right.append(b);
        line = try readLine(reader, &buffer);
    }
}

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

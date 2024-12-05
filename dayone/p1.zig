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

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

pub fn loadData(left: *ArrayList(i32), right: *ArrayList(i32)) !void {
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

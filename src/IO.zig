const std = @import("std");

const assert = std.debug.assert;
const os = std.os;
const linux = os.linux;
const IO_Uring = linux.IO_Uring;
const io_uring_cqe = linux.io_uring_cqe;
const io_uring_sqe = linux.io_uring_sqe;
const log = std.log.scoped(.io);

pub const IO = struct {
    io_uring: IO_Uring,


    pub fn init() !IO {
        var entries:u13 = 2048;
        var flags:u32 = 0;

        var io_uring:IO_Uring = try IO_Uring.init(entries, flags);

        return IO 
            {
            .io_uring  = io_uring
            };
    }

    pub fn deinit(self:*IO) void {
        self.io_uring.deinit();
    }
};

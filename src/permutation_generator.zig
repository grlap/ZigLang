const std = @import("std");

pub const PermutationGenerator = struct {
    allocator: std.mem.Allocator,
    count: u64,
    // The array holding the current permutation.
    //
    sequence : []u64,
    is_choosen : []bool,

    // Creates a new Permutation Generator on the heap.
    //
    pub fn create(
        allocator: std.mem.Allocator,
        count: u64,
    ) !*@This() {
        const self = allocator.create(@This()) catch unreachable;

        self.* = try PermutationGenerator.init(allocator, count);

        return self;
    }

    // Initializes a new Permutation Generator.
    //
    pub fn init(
        allocator: std.mem.Allocator,
        count: u64,
    ) !PermutationGenerator {
        var sequence :[]u64 = try allocator.alloc(u64, count);
        errdefer allocator.free(sequence);
        //std.mem.set(u64, sequence, 0);

        var is_choosen :[]bool = try allocator.alloc(bool, count);
        errdefer allocator.free(is_choosen);
        std.mem.set(bool, is_choosen, true);

        // Set initial sequence to 1, 2, .. n
        //
        var index: usize = 0;
        while (index < count) {
            sequence[index] = index;
            index += 1;
        }

        return PermutationGenerator{
            .allocator = allocator,
            .count = count - 1,
            .sequence = sequence,
            .is_choosen = is_choosen,
        };
    }

    pub fn destroy(self: *PermutationGenerator) void {
        deinit(self.*);
        self.allocator.destroy(self);
    }

    pub fn deinit(self: PermutationGenerator) void {
            self.allocator.free(self.sequence);
            self.allocator.free(self.is_choosen);
        }

    pub fn next(self: @This()) ?[]u64 {

        var index : usize = @intCast(usize, self.count);

        // Unuse that last number in the sequence.
        //
        const last_value : u64 = self.sequence[index];
        self.is_choosen[last_value] = false;

        // Find first number that can be increased, unuse the values as we skip over them.
        //
        while (index > 0) {
            index -= 1;

            var value : u64 = self.sequence[index];
            self.is_choosen[value] = false;

            if (value < self.count) {
                // Find next available value.
                //
                value += 1;
                while (value <= self.count and self.is_choosen[value]) {
                    value += 1;
                }

                if (value > self.count or
                    (value == self.count and self.is_choosen[value])) {
                    // There are no values available, so shorten sequence.
                    //
                    continue;
                }

                self.sequence[index] = value;
                self.is_choosen[value] = true;
                index += 1;
                break;
            }
        }

        // Fill remaining portion of the sequence.
        //
        var choosen_value : u64 = 0;
        if (index == 0) {
            choosen_value = self.sequence[0] + 1;
        } 

        if (choosen_value > self.count) {
            // Termination, there are no more available permutations.
            //
            return null;
        }

        while (index <= self.count) {
            // Pick first available number from not selected numbers.
            //
            while (self.is_choosen[choosen_value]) {
                choosen_value += 1;
            }

            self.sequence[index] = choosen_value;
            self.is_choosen[choosen_value] = true;

            if (choosen_value == self.count) {
                // There are no available values higher than choosen_value.
                // However there are available lower value, so reset the choosen_value.
                //
                choosen_value = 0;
            }

            index += 1;
        }

        return self.sequence;
    }
};

struct IoVec {
  p: [*]u8,
  len: i32,
}

let stdout: i32 = 1;
let stdin:  i32 = 0;

@wasm_import("wasi_snapshot_preview1", "fd_write")
fn fd_write(fd: i32, iovec_addr: *IoVec, count: i32, n_written_ptr: *i32): i32;

@wasm_import("wasi_snapshot_preview1", "fd_read")
fn fd_read(fd: i32, iovec_addr: *IoVec, count: i32, n_read_ptr: *i32): i32;


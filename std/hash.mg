struct Hasher {
  chunk:  u32,
  result: u32,
  n:      u32,
  len:    usize,
}

fn init(h: *Hasher, seed: u32) {
  h.chunk.*  = 0;
  h.result.* = seed;
  h.n.*      = 0;
  h.len.*    = 0;
}

fn write_bytes(h: *Hasher, buff: [*]u8, len: usize) {
  let i: usize = 0;
  while i < len {
    write(h, buff[i].*);
    i = i + 1;
  }
}

fn write(h: *Hasher, b: u8) {
  h.len.* = h.len.* + 1;

  let i = h.n.*;
  if i == 0 {
    h.chunk.* = h.chunk.* | (b as u32 << 24);
    h.n.* = 1;
  } else if i == 1 {
    h.chunk.* = h.chunk.* | (b as u32 << 16);
    h.n.* = 2;
  } else if i == 2 {
    h.chunk.* = h.chunk.* | (b as u32 << 8);
    h.n.* = 3;
  } else {
    h.chunk.* = h.chunk.* | b as u32;

    // scramble
    let result = h.result.*;
    let k = h.chunk.*;
    k = k * 0xcc9e2d51;
    k = (k << 15) | (k >> 17);
    k = k * 0x1b873593;
    result = result ^ k;
    result = (result << 13) | (result >> 19);
    result = result * 5 + 0xe6546b64;
    h.result.* = result;
    h.chunk.* = 0;

    h.n.* = 0;
  }
}

fn write_i8(h: *Hasher, n: i8) {
  write(h, n as u8);
}

fn write_i16(h: *Hasher, n: i16) {
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_i32(h: *Hasher, n: i32) {
  write(h, (n >> 24) as u8);
  write(h, (n >> 16) as u8);
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_i64(h: *Hasher, n: i64) {
  write(h, (n >> 56) as u8);
  write(h, (n >> 48) as u8);
  write(h, (n >> 40) as u8);
  write(h, (n >> 32) as u8);
  write(h, (n >> 24) as u8);
  write(h, (n >> 16) as u8);
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_u8(h: *Hasher, n: u8) {
  write(h, n);
}

fn write_u16(h: *Hasher, n: u16) {
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_u32(h: *Hasher, n: u32) {
  write(h, (n >> 24) as u8);
  write(h, (n >> 16) as u8);
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_u64(h: *Hasher, n: u64) {
  write(h, (n >> 56) as u8);
  write(h, (n >> 48) as u8);
  write(h, (n >> 40) as u8);
  write(h, (n >> 32) as u8);
  write(h, (n >> 24) as u8);
  write(h, (n >> 16) as u8);
  write(h, (n >> 8) as u8);
  write(h, n as u8);
}

fn write_bool(h: *Hasher, b: bool) {
  if b {
    write(h, 1);
  } else {
    write(h, 0);
  }
}

fn sum(h: *Hasher): u32 {
  let result = h.result.*;
  let k = h.chunk.*;
  k = k * 0xcc9e2d51;
  k = (k << 15) | (k >> 17);
  k = k * 0x1b873593;
  result = result ^ k;
  result = result ^ (h.len.* as u32);
  result = result ^ (result >> 16);
  result = result * 0x85ebca6b;
  result = result ^ (result >> 13);
  result = result * 0xc2b2ae35;
  result = result ^ (result >> 16);
  return result;
}


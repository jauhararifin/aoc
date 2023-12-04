import fmt "std/fmt";
import mem "std/mem";

fn read_str(buff: [*]u8): isize {
  let len: isize = 0;
  while true {
    let s = fmt::getchar();
    if s == 0 || s == 10 {
      break;
    }

    buff[len].* = s;
    len = len + 1;
  }

  buff[len].* = 0;
  return len;
}

fn is_digit(r: isize, c: isize, board: [*]u8, i: isize, j: isize): bool {
  if i < 0 || i >= r || j < 0 || j >= c {
    return false;
  }

  let p = board[i * c + j].*;
  return p >= '0' && p <= '9';
}

fn take_number(r: isize, c: isize, board: [*]u8, i: isize, j: isize): isize {
  let start = j;
  while start > 0 && board[i*c + start-1].* >= '0' && board[i*c + start-1].* <= '9' {
    start = start - 1;
  }

  let j = start;
  let result = 0;
  while j < c && board[i*c + j].* >= '0' && board[i*c + j].* <= '9' {
    let digit = board[i*c + j].* as isize - '0';
    result = result * 10 + digit;
    board[i*c + j].* = '.';
    j = j + 1;
  }

  // fmt::print_str("digit found: ");
  // fmt::print_isize(result);
  // fmt::print_str("\n");

  return result;
}

@main()
fn main() {
  let board = mem::alloc_array::<u8>(256 * 256);
  let r = 0;
  let c = 0;

  while true {
    let n = read_str(board[r * c] as [*]u8);
    if n == 0 {
      break;
    }
    if c == 0 {
      c = n;
    }
    r = r + 1;
  }

  let result = 0;

  let i = 0;
  while i < r {
    let j = 0;
    while j < c {
      let p = board[i*c + j].*;
      let is_symbol = p != '.' && (p < '0' || p > '9');
      if !is_symbol {
        j = j + 1;
        continue;
      }

      // fmt::print_str("found symbol at ");
      // fmt::print_isize(i);
      // fmt::print_str(" ");
      // fmt::print_isize(j);
      // fmt::print_str("\n");

      if is_digit(r, c, board, i-1, j) {
        result = result + take_number(r, c, board, i-1, j);
      }
      if is_digit(r, c, board, i-1, j+1) {
        result = result + take_number(r, c, board, i-1, j+1);
      }
      if is_digit(r, c, board, i, j+1) {
        result = result + take_number(r, c, board, i, j+1);
      }
      if is_digit(r, c, board, i+1, j+1) {
        result = result + take_number(r, c, board, i+1, j+1);
      }
      if is_digit(r, c, board, i+1, j) {
        result = result + take_number(r, c, board, i+1, j);
      }
      if is_digit(r, c, board, i+1, j-1) {
        result = result + take_number(r, c, board, i+1, j-1);
      }
      if is_digit(r, c, board, i, j-1) {
        result = result + take_number(r, c, board, i, j-1);
      }
      if is_digit(r, c, board, i-1, j-1) {
        result = result + take_number(r, c, board, i-1, j-1);
      }

      j = j + 1;
    }
    i = i + 1;
  }

  fmt::print_isize(result);
  fmt::print_str("\n");
}

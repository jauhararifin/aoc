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

fn streq(str: [*]u8, pat: [*]u8): bool {
  let pat_len = 0;
  while pat[pat_len].* != 0 {
    pat_len = pat_len + 1;
  }

  let str_len = 0;
  while str[str_len].* != 0 {
    str_len = str_len + 1;
  }

  if str_len < pat_len {
    return false;
  }

  let i = 0;
  while i < pat_len {
    if str[i].* != pat[i].* {
      return false;
    }
    i = i + 1;
  }
  return true;
}

@main()
fn main() {
  let result: i64 = 0;

  let buff = mem::alloc_array::<u8>(256);
  while true {
    let first: i64 = -1;
    let last:  i64 = -1;
    let done = false;

    let len = read_str(buff);
    if len == 0 {
      break;
    }

    let i = 0;
    while i < len {
      let digit: i64 = -1;
      if buff[i].* >= 48 && buff[i].* <= 57 {
        digit = (buff[i].* - 48) as i64;
      } else if streq(buff[i] as [*]u8, "one") {
        digit = 1;
      } else if streq(buff[i] as [*]u8, "two") {
        digit = 2;
      } else if streq(buff[i] as [*]u8, "three") {
        digit = 3;
      } else if streq(buff[i] as [*]u8, "four") {
        digit = 4;
      } else if streq(buff[i] as [*]u8, "five") {
        digit = 5;
      } else if streq(buff[i] as [*]u8, "six") {
        digit = 6;
      } else if streq(buff[i] as [*]u8, "seven") {
        digit = 7;
      } else if streq(buff[i] as [*]u8, "eight") {
        digit = 8;
      } else if streq(buff[i] as [*]u8, "nine") {
        digit = 9;
      }

      if digit != -1 {
        if first == -1 {
          first = digit;
          last = digit;
        } else {
          last = digit;
        }
      }

      i = i + 1;
    }

    if first != -1 {
      result = result + (first * 10 + last);
    }

    if done {
      break;
    }
  }

  fmt::print_i64(result);
  fmt::print_str("\n");
}

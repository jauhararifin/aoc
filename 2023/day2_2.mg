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

fn str_starts_with(str: [*]u8, pat: [*]u8): bool {
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
  let s = mem::alloc_array::<u8>(256);

  let result: i64 = 0;

  while true {
    let ns = read_str(s);
    if ns == 0 {
      break;
    }

    let id: i32 = 0;
    let i = 5;
    while s[i].* != ':' {
      id = (id * 10) + (s[i].* - '0') as i32;
      i = i + 1;
    }

    let max_red: i64 = 0;
    let max_green: i64 = 0;
    let max_blue: i64 = 0;

    while i < ns {
      let red: i64 = 0;
      let green: i64 = 0;
      let blue: i64 = 0;
      while true {
        while i < ns && (s[i].* < '0' || s[i].* > '9') {
          i = i + 1;
        }

        if i >= ns {
          break;
        }

        let n: i64 = 0;
        while s[i].* >= '0' && s[i].* <= '9' {
          n = (n * 10) + (s[i].* - '0') as i64;
          i = i + 1;
        }
        // fmt::print_str("n=");fmt::print_i32(n);fmt::print_str("\n");

        i = i + 1;
        if str_starts_with(s[i] as [*]u8, "red") {
          // fmt::print_str("red\n");
          red = n;
        } else if str_starts_with(s[i] as [*]u8, "green") {
          // fmt::print_str("green\n");
          green = n;
        } else {
          // fmt::print_str("blue\n");
          blue = n;
        }

        while s[i].* >= 'a' && s[i].* <= 'z' {
          i = i + 1;
        }

        if s[i].* == ';' {
          i = i + 1;
          break;
        } else {
          i = i + 1;
        }
      }

      // fmt::print_str(">>> "); fmt::print_i32(id); fmt::print_str("\n");
      // fmt::print_str("id="); fmt::print_i32(id);
      // fmt::print_str(",red="); fmt::print_i32(red);
      // fmt::print_str(",green="); fmt::print_i32(green);
      // fmt::print_str(",blue="); fmt::print_i32(blue);
      // fmt::print_str("\n");

      if red > max_red {
        max_red = red;
      }
      if blue > max_blue {
        max_blue = blue;
      }
      if green > max_green {
        max_green = green;
      }
    }

    result = result + max_red * max_green * max_blue;

  }

  fmt::print_i64(result);
  fmt::print_str("\n");
}

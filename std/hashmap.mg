import allocator "std/allocator";
import option "std/option";

struct HashMap<K,V> {
  allocator:   allocator::Allocator,
  fn_hash:     fn(K): u32,
  fn_eq:       fn(K, K): bool,
  fn_free_key: fn(K),
  fn_free_val: fn(V),

  table:  [*]Entry<K,V>,
  len:    usize,
  n:      usize,
}

let STATUS_EMPTY:   u8 = 0;
let STATUS_ENTRY:   u8 = 0;
let STATUS_DELETED: u8 = 0;

struct Entry<K,V> {
  status: u8,
  hash:   u32,
  key:    K,
  value:  V,
}

fn new<K,V>(
  allocator:   allocator::Allocator,
  fn_hash:     fn(K): u32,
  fn_eq:       fn(K, K): bool,
  fn_free_key: fn(K),
  fn_free_val: fn(V),
): HashMap<K,V> {
  return HashMap::<K,V> {
    allocator:   allocator,
    fn_hash:     fn_hash,
    fn_eq:       fn_eq,
    fn_free_key: fn_free_key,
    fn_free_val: fn_free_val,

    table: 0 as [*]Entry<K,V>,
    len:   0,
  };
}

fn insert<K,V>(h: *HashMap<K,V>, key: K, value: V) {
  let hash = h.fn_hash.*(key);
  insert_with_hash::<K,V>(h, hash, key, value);
}

fn insert_with_hash<K,V>(h: *HashMap<K,V>, hash: u32, key: K, value: V) {
  if h.len.* == 0 {
    grow::<K,V>(h);
  }

  let i = (hash as usize) % h.len.*;
  while true {
    let status = h.table.*[i].status.*;
    if status == STATUS_EMPTY {
      break
    }
    if status == STATUS_DELETED {
      break;
    }
    if hash == h.table.*[i].hash.* && h.fn_eq.*(key, h.table.*[i].key.*) {
      break;
    }
    i = (i + 1) % h.len.*;
  }

  if h.table.*[i].status.* == STATUS_ENTRY {
    h.fn_free_key.*(h.table.*[i].key.*);
    h.fn_free_val.*(h.table.*[i].value.*);
  } else {
    h.n.* = h.n.* + 1;
  }

  h.table.*[i].* = Entry::<K,V> {
    status: STATUS_ENTRY,
    hash:   hash,
    key:    key,
    value:  value,
  }

  if h.n.* * 3 > h.len.* * 2 {
    grow::<K,V>(h);
  }
}

fn delete<K,V>(h: *HashMap<K,V>, key: K) {
  let hash = h.fn_hash.*(key);
  if h.len.* == 0 {
    return;
  }

  let i = (hash as usize) % h.len.*;
  while true {
    let status = h.table.*[i].status.*;
    if status == STATUS_EMPTY {
      return;
    }
    if hash == h.table.*[i].hash.* && h.fn_eq.*(key, h.table.*[i].key.*) {
      break;
    }
    i = (i + 1) % h.len.*;
  }

  if h.table.*[i].status.* == STATUS_ENTRY {
    h.fn_free_key.*(h.table.*[i].key.*);
    h.fn_free_val.*(h.table.*[i].value.*);
    h.table.*[i].status.* = STATUS_DELETED;
    h.n.* = h.n.* - 1;
  }
}

fn grow<K,V>(h: *HashMap<K,V>) {
  let old_size = h.len.*;
  let new_size = old_size * 2;
  if new_size == 0 {
    new_size = 8;
  }

  let old_table = h.table.*;
  h.table.* = allocator::alloc_array::<Entry<K,V>>(h.allocator.*, new_size);
  h.len.* = new_size;

  let i: usize = 0;
  while i < new_size {
    h.table.*[i].status.* = STATUS_EMPTY;
    i = i + 1;
  }

  let i: usize = 0;
  while i < old_size {
    if old_table[i].status.* == STATUS_ENTRY {
      insert_with_hash::<K,V>(h, old_table[i].hash.*, old_table[i].key.*, old_table[i].value.*);
    }
    i = i + 1;
  }

  allocator::dealloc_array::<Entry<K,V>>(h.allocator.*, h.table.*);
}

fn get<K,V>(h: *HashMap<K,V>, key: K): option::Option<V> {
  let result = get_ptr::<K,V>(h, key);
  if !result.ok {
    return option::none::<V>();
  }

  return option::some::<V>(result.value.*);
}

fn get_ptr<K,V>(h: *HashMap<K,V>, key: K): option::Option< *V> {
  let hash = h.fn_hash.*(key);

  let i = hash as usize % h.len.*;
  while true {
    let status = h.table.*[i].status.*;
    if status == STATUS_ENTRY && hash == h.table.*[i].hash.* && h.fn_eq.*(key, h.table.*[i].key.*) {
      return option::some::< *V>(h.table.*[i].value);
    }
    if status == STATUS_EMPTY {
      return option::none::< *V>();
    }
    i = (i + 1) % h.len.*;
  }

  return option::none::< *V>();
}

fn size<K,V>(h: *HashMap<K,V>): usize {
  return h.n.*;
}

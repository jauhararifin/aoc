import wasm "std/wasm";

struct Allocator {
  handle:  *void,
  alloc:   fn( *void, usize): usize,
  dealloc: fn( *void, usize),
}

fn alloc<T>(a: Allocator): *T {
  return a.alloc(a.handle, wasm::size_of::<T>()) as *T;
}

fn alloc_array<T>(a: Allocator, n: usize): [*]T {
  return a.alloc(a.handle, wasm::size_of::<T>() * n) as [*]T;
}

fn dealloc<T>(a: Allocator, ptr: *T) {
  return a.dealloc(a.handle, ptr as usize);
}

fn dealloc_array<T>(a: Allocator, ptr: [*]T) {
  return a.dealloc(a.handle, ptr as usize);
}

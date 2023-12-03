struct Option<T> {
  ok:    bool,
  value: T,
}

fn some<T>(value: T): Option<T> {
  return Option::<T>{ok: true, value: value};
}

fn none<T>(): Option<T> {
  return Option::<T>{ok: false};
}

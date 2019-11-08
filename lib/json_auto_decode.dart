import 'dart:collection';

T jsonAutoDecode<T>(String encoded) =>
    throw UnsupportedError('We needed a static type!');

/// Lazily converts one list into another list based on a conversion function.
///
/// Destructive on the original list for efficiency reasons.
class LazyList<T> extends ListBase<T> {
  final List<dynamic> _original;
  final _converted = <T>[];
  final T Function(dynamic) _converter;

  LazyList(this._original, this._converter) {
    // Important for `add`, `addAll`, and `length` to work properly
    _converted.length = _original.length;

    // We don't have a way of distinguishing between Null and unassigned.
    if (T == Null) {
      throw UnsupportedError('LazyList<$T> is not allowed');
    }
  }

  @override
  void add(T value) => _converted.add(value);

  @override
  void addAll(Iterable<T> values) => _converted.addAll(values);

  @override
  T operator [](int index) {
    return _converted[index] ??= () {
      var original = _original[index];
      _original[index] = null;
      return _converter(original);
    }();
  }

  @override
  void operator []=(int index, T value) {
    if (index < _original.length) _original[index] = null;
    _converted[index] = value;
  }

  @override
  int get length => _converted.length;

  @override
  set length(int newLength) {
    if (newLength < _original.length) _original.length = newLength;
    _converted.length = newLength;
  }
}

/// Lazily converts one map into another map based on a conversion function.
///
/// Destructive on the original map for efficiency reasons.
class LazyMap<V> extends MapBase<String, V> {
  final Map<String, dynamic> _original;
  final _converted = <String, V>{};
  final V Function(dynamic) _converter;

  LazyMap(this._original, this._converter);

  @override
  V operator [](Object key) {
    if (_converted.containsKey(key)) {
      return _converted[key];
    }
    if (_original.containsKey(key)) {
      var original = _original.remove(key);
      return _converted[key as String] = _converter(original);
    }
    return null;
  }

  @override
  void operator []=(String key, V value) {
    _converted[key] = value;
    _original.remove(key);
  }

  @override
  void clear() {
    _original.clear();
    _converted.clear();
  }

  @override
  Iterable<String> get keys => _original.keys.followedBy(_converted.keys);

  @override
  V remove(Object key) {
    if (_original.containsKey(key)) {
      var original = _original.remove(key);
      return _converter(original);
    }
    return _converted.remove(key);
  }
}

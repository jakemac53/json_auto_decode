import 'dart:collection';
import 'dart:typed_data';

T jsonAutoDecode<T>(String encoded) =>
    throw UnsupportedError('We needed a static type!');

T jsonAutoDecodeFromBytes<T>(Uint8List bytes) =>
    throw UnsupportedError('We needed a static type!');

Iterable<T> convertIterable<S, T>(Iterable<S> json, T Function(S) converter,
        {Iterable<T> defaultValue}) =>
    json?.map((v) => converter(v)) ?? defaultValue;

List<T> convertList<S, T>(Iterable<S> json, T Function(S) converter,
    {List<T> defaultValue}) {
  if (json == null) return null;
  return [for (var item in json) converter(item)];
}

Map<K2, V2> convertMap<K1, V1, K2, V2>(Map<K1, V1> json,
    K2 Function(K1) keyConverter, V2 Function(V1) valueConverter,
    {Map<K2, V2> defaultValue}) {
  if (json == null) return null;
  return {
    for (var entry in json.entries)
      keyConverter(entry.key): valueConverter(entry.value)
  };
}

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

/// Lazily converts the values of one map into another map based on a
/// conversion function.
///
/// This does not support converting the keys because that would have to be
/// eager.
///
/// Destructive on the original map for efficiency reasons.
class LazyMap<K, V> extends MapBase<K, V> {
  final Map<K, dynamic> _original;
  final _converted = <K, V>{};
  final V Function(dynamic) _converter;

  LazyMap(this._original, this._converter);

  @override
  V operator [](Object key) {
    if (_converted.containsKey(key)) {
      return _converted[key];
    }
    if (_original.containsKey(key)) {
      var original = _original.remove(key);
      return _converted[key as K] = _converter(original);
    }
    return null;
  }

  @override
  void operator []=(K key, V value) {
    _converted[key] = value;
    _original.remove(key);
  }

  @override
  void clear() {
    _original.clear();
    _converted.clear();
  }

  @override
  Iterable<K> get keys => _original.keys.followedBy(_converted.keys);

  @override
  V remove(Object key) {
    if (_original.containsKey(key)) {
      var original = _original.remove(key);
      return _converter(original);
    }
    return _converted.remove(key);
  }
}

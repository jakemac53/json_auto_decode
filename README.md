Experimental automatic conversion from JSON Strings to strongly typed Dart
Objects!

## Usage

### Clone a custom fork of the sdk and build it

From your local sdk checkout, do:

```
git checkout -b json-auto-decode
git pull https://github.com/jakemac53/sdk/ json-auto-decode

./tools/build.py -mrelease --arch x64 create_sdk
// Now use this sdk when running dart files
```

### Depend on this package via git

```yaml
dependencies:
  json_auto_decode:
    git: https://github.com/jakemac53/json_auto_decode.git
```

### Import and use this package

```
import 'package:json_auto_decode/json_auto_decode.dart';
```

Then call `jsonAutoDecode<T>(String)` with your desired types.

For example:

```
class User {
  final String name;
  final int age;

  User(this.name, {this.age});
}

var userData = '''
[
  {"name" : "john", "age": 20},
  {"name" : "jill"}
]
''';

main() {
  var users = jsonAutoDecode<List<User>>(userData); 
}
```

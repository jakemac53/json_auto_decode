import 'package:json_auto_decode/json_auto_decode.dart';

void main() {
  var groups = jsonAutoDecode<Iterable<Group<User>>>(userData);
  print(groups.map((group) => '''
group id: ${group.id}
members: ${group.items.map((u) => u.name).join(', ')}
''').join('\n'));
}

final userData = '''
[
  {
    "id": "userGroup1234",
    "items": [
      {"name": "Jake"},
      {"name": "Bob"},
      {"name": "Emily"}
    ]
  },
  {
    "id": "userGroup5678",
    "items": [
      {"name": "Linda"},
      {"name": "Alex"}
    ]
  }
]
''';

class User {
  final String name;

  User(this.name);
}

class Group<T> {
  final String id;
  final Iterable<T> items;

  Group(this.id, this.items);
}

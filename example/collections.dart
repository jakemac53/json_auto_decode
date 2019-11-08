import 'package:json_auto_decode/json_auto_decode.dart';

void main() {
  var data = jsonAutoDecode<Map<String, List<Map<String, List<int>>>>>('''
{
  "a" : [
    {
      "b": [
        1, 2, 3
      ]
    }
  ] 
}  
''');
  // Note that implicit casts are disabled, but we have an actual type of int
  // all the way down here.
  int two = data['a'].first['b'][1];
  print(two);
}

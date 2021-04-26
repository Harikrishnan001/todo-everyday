import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

class QuotePicker {
  static Future<Map<String, String>> fetchQuote() async {
    var url = Uri.parse("https://type.fit/api/quotes");
    final response = await http.get(url);
    final List<dynamic> jsonList = jsonDecode(response.body);
    final jsonListMap = jsonList.map((e) {
      var map = e as Map<String, dynamic>;
      return map.map((key, value) => MapEntry(key, value.toString()));
    }).toList();
    final index = Random().nextInt(jsonListMap.length - 1);
    return jsonListMap[index];
  }
}

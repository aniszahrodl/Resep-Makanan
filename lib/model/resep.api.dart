import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:resep_masak/model/resep.dart';

class ResepApi {
  static Future<List<Resep>> getResep() async {
    var uri = Uri.https('tasty.p.rapidapi.com', '/recipes/list',
        {"from": '0', "size": '20', "tags": 'under_30_minutes'});

    final response = await http.get(uri, headers: {
      'x-rapidapi-key': '9b619c622cmsh2ef13117b90f3a1p1381f2jsnf8ce57c4bd31',
      'x-rapidapi-host': 'tasty.p.rapidapi.com'
    });

    Map data = jsonDecode(response.body);

    List _temp = [];

    for (var i in data['results']) {
      _temp.add(i);
    }

    return Resep.resepFromSnapshot(_temp);
  }
}

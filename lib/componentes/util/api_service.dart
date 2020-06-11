import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iselectaplication1990/datas/pais_data.dart';

class ApiService {
  static String url(int nrResults) {
    return 'http://api.randomuser.me/?results=$nrResults';
  }

  static Future<List<Pais>> getUsers({int nrUsers = 1}) async {
    try {
      var response =
      await http.get(url(nrUsers), headers: {"Content-Type": "application/json"});

      if(response.statusCode == 200){
        Map data = json.decode(response.body);
        Iterable list = data["results"];
        List<Pais> users = list.map((l)=>Pais.fromJson(l)).toList();
        return users;
      } else {
        print(response.body);
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
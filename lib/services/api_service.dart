import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getPuuid(riotId) async {
    String riotName = riotId.slice("#")[0];
    String tag = riotId.slice("#")[1];
    String puuid = "";
    const baseUri =
        'https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id';

    final url = Uri.parse('$baseUri/$riotName/$tag?api_key=');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> riotUserInfo = jsonDecode(response.body);
      puuid = riotUserInfo['puuid'] ? riotUserInfo['puuid'] : "";
      return puuid;
    }
    throw Error();
  }
}

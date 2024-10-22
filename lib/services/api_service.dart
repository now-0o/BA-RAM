import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getPuuid(riotId) async {
    String puuid = "";
    const baseUri =
        'https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id/%EB%8F%99%EA%B7%B8%EB%9D%BC%EB%B0%8D/KR1?api_key=';

    final url = Uri.parse(baseUri);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> riotUserInfo = jsonDecode(response.body);
      puuid = riotUserInfo['puuid'] ? riotUserInfo['puuid'] : "";
      return puuid;
    }
    throw Error();
  }
}

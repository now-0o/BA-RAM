import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:baram/models/summoner_profile.dart';

class ApiService {
  // PUUID와 Summoner Profile 가져오기
  static Future<SummonerProfile> getSummonerProfile(String riotId) async {
    List<String> parts = riotId.split("#");
    String riotName = parts[0];
    String tag = parts[1];

    const baseUri =
        'https://asia.api.riotgames.com/riot/account/v1/accounts/by-riot-id';

    final url = Uri.parse(
        '$baseUri/$riotName/$tag?api_key=RGAPI-c7c497f6-9280-40e7-b817-0134f9afe3c4');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> riotUserInfo = jsonDecode(response.body);
      final String puuid = riotUserInfo['puuid'] ?? "";

      if (puuid.isNotEmpty) {
        const baseUri2 =
            'https://kr.api.riotgames.com/lol/summoner/v4/summoners/by-puuid';

        final url2 = Uri.parse(
            '$baseUri2/$puuid?api_key=RGAPI-c7c497f6-9280-40e7-b817-0134f9afe3c4');
        final response2 = await http.get(url2);

        if (response2.statusCode == 200) {
          final Map<String, dynamic> profile = jsonDecode(response2.body);
          // 필요한 값들을 문자열로 변환
          profile['profileIconId'] = profile['profileIconId'].toString();
          profile['summonerLevel'] = profile['summonerLevel'].toString();

          return SummonerProfile.fromJson(profile);
        } else {
          throw Exception('Failed to load Summoner Profile');
        }
      } else {
        throw Exception('PUUID is empty');
      }
    } else {
      throw Exception('Failed to load PUUID');
    }
  }
}

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

      print(puuid);
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

  static Future<List<bool>> getAramTier(String riotId) async {
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
        // 게임 ID 목록 가져오기
        const baseUri2 =
            'https://asia.api.riotgames.com/lol/match/v5/matches/by-puuid';
        final url2 = Uri.parse(
            '$baseUri2/$puuid/ids?queue=450&start=0&count=10&api_key=RGAPI-c7c497f6-9280-40e7-b817-0134f9afe3c4');
        print('url2:$url2');
        final response2 = await http.get(url2);

        if (response2.statusCode == 200) {
          List<dynamic> matchIds = jsonDecode(response2.body);

          // 각 게임 ID에 대해 승패 여부를 조회
          List<bool> results = [];
          for (String matchId in matchIds) {
            bool win = await _checkWin(matchId, puuid);
            results.add(win);
          }
          return results;
        } else {
          throw Exception('Failed to load match IDs');
        }
      } else {
        throw Exception('PUUID is empty');
      }
    } else {
      throw Exception('Failed to load PUUID');
    }
  }

  // 개별 게임의 승리 여부 확인 함수
  static Future<bool> _checkWin(String matchId, String puuid) async {
    int wincount = 0;
    final url = Uri.parse(
        'https://asia.api.riotgames.com/lol/match/v5/matches/$matchId?api_key=RGAPI-c7c497f6-9280-40e7-b817-0134f9afe3c4');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> matchData = jsonDecode(response.body);
      final participants = matchData['info']['participants'] as List;

      // 해당 puuid의 플레이어 찾기
      final player = participants.firstWhere(
        (participant) => participant['puuid'] == puuid,
        orElse: () => null,
      );

      if (player != null) {
        var name = player['summonerName'];
        print(name);
        var kills = player['kills'];
        print(kills);

        bool win = player['win'];
        print(win);
      }

      if (player != null) {
        return player['win'];
      } else {
        throw Exception('Player not found in match');
      }
    } else {
      throw Exception('Failed to load match details');
    }
  }
}

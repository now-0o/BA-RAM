class SummonerProfile {
  final String id, accountId, profileIconId, summonerLevel;

  SummonerProfile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        accountId = json['accountId'],
        profileIconId = json['profileIconId'],
        summonerLevel = json['summonerLevel'];
}

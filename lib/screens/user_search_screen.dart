import 'package:baram/models/summoner_profile.dart';
import 'package:flutter/material.dart';
import 'package:baram/services/api_service.dart';

class UserSearchScreen extends StatefulWidget {
  final String riotId; // riotId 전달받기

  // 생성자에서 riotId를 받아오기
  const UserSearchScreen({
    super.key,
    required this.riotId, // 이 부분 추가
  });

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  late Future<SummonerProfile> summonerProfile =
      ApiService.getSummonerProfile(widget.riotId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder(
                      future: summonerProfile,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  width: 100,
                                  'https://ddragon.leagueoflegends.com/cdn/14.21.1/img/profileicon/${snapshot.data!.profileIconId}.png',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 4.0), // 내부 여백
                                decoration: BoxDecoration(
                                  color: Colors.black, // 검은색 배경
                                  borderRadius: BorderRadius.circular(
                                      4.0), // 약간 둥근 모서리 (선택 사항)
                                ),
                                child: Text(
                                  snapshot.data!.summonerLevel,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.riotId.split("#")[0],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              '#${widget.riotId.split("#")[1]}',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 1), // 패딩 조정
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4), // 둥근 모서리 반경 설정
                            ),
                            backgroundColor:
                                const Color(0xff5079FF), // 버튼 배경 색상
                          ),
                          onPressed: () {},
                          child: const Text(
                            '전적갱신',
                            style: TextStyle(
                              color: Colors.white, // 텍스트 색상 설정
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

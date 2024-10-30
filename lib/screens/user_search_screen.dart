import 'package:baram/models/summoner_profile.dart';
import 'package:flutter/material.dart';
import 'package:baram/services/api_service.dart';

class UserSearchScreen extends StatefulWidget {
  final String riotId; // riotId 전달받기

  const UserSearchScreen({
    super.key,
    required this.riotId,
  });

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  late Future<SummonerProfile> summonerProfile;
  List<bool>? aramWinList; // 승패 목록 저장
  bool isLoading = false; // 로딩 상태 표시
  int score = 0;

  @override
  void initState() {
    super.initState();
    summonerProfile = ApiService.getSummonerProfile(widget.riotId);
  }

  // 승패 조회 함수
  Future<void> _fetchAramTier() async {
    setState(() {
      isLoading = true; // 로딩 시작
    });

    try {
      final result = await ApiService.getAramTier(widget.riotId);
      setState(() {
        aramWinList = result; // 승패 목록 저장
      });
      score = await countWin();
    } catch (e) {
      print('오류 발생: $e'); // 오류 처리
    } finally {
      setState(() {
        isLoading = false; // 로딩 종료
      });
    }
  }

  Future<int> countWin() async {
    int localCount = 0;
    int localScore = 0;
    bool localCheck = false;

    for (var win in aramWinList!) {
      if (win != localCheck) {
        localCount = 0;
      }

      if (win == true) {
        localCount = localCount + 5;
        localScore += (localCount + 23);
      } else {
        localCount = localCount - 4;
        localScore += (localCount - 19);
      }

      localCheck = win;
      print('승패: $win, localCount: $localCount, localScore: $localScore');
    }

    return localScore; // 최종 점수 반환
  }

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
                                    horizontal: 6.0, vertical: 4.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(4.0),
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
                    const SizedBox(width: 20),
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
                            const SizedBox(
                              width: 40,
                            ),
                            Text('점수 : $score'),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            backgroundColor: const Color(0xff5079FF),
                          ),
                          onPressed: _fetchAramTier, // 승패 조회 함수 연결
                          child: const Text(
                            '전적갱신',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Column으로 승패 목록을 표시
          if (isLoading)
            const CircularProgressIndicator() // 로딩 표시
          else if (aramWinList != null)
            Expanded(
              child: ListView.builder(
                itemCount: aramWinList!.length,
                itemBuilder: (context, index) {
                  final isWin = aramWinList![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isWin ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isWin ? '승리' : '패배',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const Text('데이터가 없습니다.'),
        ],
      ),
    );
  }
}

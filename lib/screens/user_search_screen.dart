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
  late Future<String> puuid;

  @override
  void initState() {
    super.initState();

    puuid = ApiService.getPuuid(widget.riotId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  const Text('소환사 아이콘자리'),
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
                          backgroundColor: const Color(0xff5079FF), // 버튼 배경 색상
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
            ],
          )
        ],
      ),
    );
  }
}

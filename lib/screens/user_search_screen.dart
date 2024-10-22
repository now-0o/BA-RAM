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
      appBar: AppBar(
        title: const Text('검색 결과'),
      ),
      body: Center(
        child: Text(
          '입력한 Riot ID: ${widget.riotId}',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

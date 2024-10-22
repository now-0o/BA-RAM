import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final riotIdController = TextEditingController();

  String? validateRiotId(String? value) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9_-]{3,16}#[a-zA-Z0-9]+$');

    if (value == null || value.isEmpty) {
      return '플레이어 이름과 태그를 입력하세요.';
    } else if (!regex.hasMatch(value)) {
      return '이름은 3~16자이며, 형식은 "이름#태그"여야 합니다.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('imgs/BA-RAM_blue.png'),
                IconButton(
                    iconSize: 40,
                    color: Colors.black.withOpacity(0.3),
                    onPressed: () {},
                    icon: const Icon(Icons.account_circle))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              child: TextFormField(
                controller: riotIdController, // 닉네임 입력 값 제어
                decoration: InputDecoration(
                  hintText: '소환사 이름 + #태그명',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey, // 테두리 색상
                      width: 1.0, // 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(8.0), // 둥근 모서리
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff5079FF), // 포커스 시 테두리 색상
                      width: 1.0, // 포커스 시 테두리 두께
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: validateRiotId, // 유효성 검사 함수 연결
              ),
            )
          ],
        ),
      ),
    );
  }
}

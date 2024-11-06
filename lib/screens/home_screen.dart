import 'package:flutter/material.dart';
import 'user_search_screen.dart'; // UserSearchScreen 임포트
import 'package:baram/widgets/patch_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final riotIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // 폼 상태 관리 키
  // 유효성 검사 함수
  String? validateRiotId(String? value) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9가-힣_-]{3,16}#[a-zA-Z0-9]+$');
    if (value == null || value.isEmpty) {
      return '플레이어 이름과 태그를 입력하세요.';
    } else if (!regex.hasMatch(value)) {
      return '이름은 3~16자이며, 형식은 "소환사 이름+#태그"여야 합니다.';
    }
    return null;
  }

  // 폼 제출 함수: 유효성 검사 후 UserSearchScreen으로 이동
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserSearchScreen(
            riotId: riotIdController.text, // 입력된 riotId 전달
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('imgs/BA-RAM_blue.png'),
                IconButton(
                  iconSize: 40,
                  color: Colors.black.withOpacity(0.3),
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: riotIdController,
                    decoration: InputDecoration(
                      hintText: '소환사 이름 + #태그명',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xff5079FF),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: validateRiotId,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) => _submitForm(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              children: [
                Text(
                  '패치노트',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 16),
                ...List.generate(
                  4,
                  (index) => Row(
                    children: [
                      PatchCard(
                        version: '14.${21 - index}',
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

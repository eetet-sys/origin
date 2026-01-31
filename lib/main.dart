import 'package:flutter/material.dart';

void main() {
  runApp(const SikgyeolApp());
}

class SikgyeolApp extends StatelessWidget {
  const SikgyeolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '식결',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F1EC),
        fontFamily: 'Roboto',
      ),
      home: const TodayPage(),
    );
  }
}

class TodayPage extends StatefulWidget {
  const TodayPage({super.key});

  @override
  State<TodayPage> createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  final TextEditingController _foodController = TextEditingController();
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식결'),
        backgroundColor: const Color(0xFFF4F1EC),
        elevation: 0,
        foregroundColor: const Color(0xFF3B2F2A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TodaySummaryCard(),
            const SizedBox(height: 16),
            _FoodInputCard(
              controller: _foodController,
              onSubmit: () {
                setState(() {
                  _showResult = true;
                });
              },
            ),
            if (_showResult) ...[
              const SizedBox(height: 16),
              const _FoodResultCard(),
              const SizedBox(height: 16),
              const _BalanceGuideCard(),
              const SizedBox(height: 16),
              const _MovementCard(),
            ],
          ],
        ),
      ),
    );
  }
}

/* ---------- 카드 컴포넌트들 ---------- */

class _TodaySummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '오늘의 정리',
      child: const Text(
        '토 중심 · 수 보완이 필요한 흐름\n'
        '오늘은 과하지 않은 선택이 기준입니다.',
        style: TextStyle(height: 1.6),
      ),
    );
  }
}

class _FoodInputCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _FoodInputCard({
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '오늘 먹을 음식은?',
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '예: 굴국, 라면, 아이스커피',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B2F2A),
                foregroundColor: Colors.white,
              ),
              child: const Text('결과 보기'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodResultCard extends StatelessWidget {
  const _FoodResultCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '음식 판단',
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '굴국 → 조건부 괜찮음',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '따뜻하지만 소화에 에너지가 조금 쓰일 수 있어요.',
          ),
          SizedBox(height: 8),
          Text(
            '국물은 줄이고 천천히 먹는 쪽이 편합니다.',
          ),
        ],
      ),
    );
  }
}

class _BalanceGuideCard extends StatelessWidget {
  const _BalanceGuideCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '오늘의 보완 포인트',
      child: const Text(
        '소화에 에너지가 쓰인 날이라\n'
        '몸을 더 쓰기보다는 회복 쪽이 좋습니다.',
        style: TextStyle(height: 1.6),
      ),
    );
  }
}

class _MovementCard extends StatefulWidget {
  const _MovementCard();

  @override
  State<_MovementCard> createState() => _MovementCardState();
}

class _MovementCardState extends State<_MovementCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: '오늘의 움직임 제안',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('몸을 덜 소모하는 방향'),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Text(_expanded ? '접기' : '열기'),
          ),
          if (_expanded) ...[
            const Divider(),
            const Text(
              '추천되는 움직임',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('- 짧은 산책\n- 가벼운 스트레칭'),
            const SizedBox(height: 12),
            const Text(
              '오늘은 피하면 좋은 움직임',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('- 장시간 고강도 운동'),
          ],
        ],
      ),
    );
  }
}

/* ---------- 공통 카드 ---------- */

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF3B2F2A),
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
// first push to github

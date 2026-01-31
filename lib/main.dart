import 'package:flutter/material.dart';
import 'data/food_classifier.dart';
import 'data/food_data.dart';

void main() {
  runApp(const SikGyeolApp());
}

class SikGyeolApp extends StatelessWidget {
  const SikGyeolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FoodCheckPage(),
    );
  }
}

class FoodCheckPage extends StatefulWidget {
  const FoodCheckPage({super.key});

  @override
  State<FoodCheckPage> createState() => _FoodCheckPageState();
}

class _FoodCheckPageState extends State<FoodCheckPage> {
  final TextEditingController birthCtrl = TextEditingController();
  final TextEditingController foodCtrl = TextEditingController();

  String element = '';
  int score = 50;
  String decisionSummary = '';

  List<String> suggestions = [];

  /* ================= 체질 계산 ================= */

  String calcElement(String birth) {
    if (birth.length < 4) return '';
    final year = int.tryParse(birth.substring(0, 4));
    if (year == null) return '';

    final stems = ['갑','을','병','정','무','기','경','신','임','계'];
    final stem = stems[(year - 4) % 10];

    if (['갑','을'].contains(stem)) return '목';
    if (['병','정'].contains(stem)) return '화';
    if (['무','기'].contains(stem)) return '토';
    if (['경','신'].contains(stem)) return '금';
    return '수';
  }

  /* ================= 자동완성 ================= */

  void updateSuggestions(String input) {
    if (input.isEmpty) {
      setState(() => suggestions.clear());
      return;
    }

    setState(() {
      suggestions = allFoodKeywords
          .where((f) => f.contains(input))
          .take(6)
          .toList();
    });
  }

  /* ================= 평가 로직 ================= */

  void evaluate() {
    score = 50;
    final foods = foodCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final reasons = <String>{};
    final weightTable = bodyFoodWeight[element];

    for (final food in foods) {
      final profile = classifyFood(food);
      score += 2; // 기본점수

      void apply(List<String> values, Map<String, int>? table) {
        if (table == null) return;
        for (final v in values) {
          if (table.containsKey(v)) {
            score += table[v]!;
            if (table[v]! < 0) reasons.add(v);
          }
        }
      }

      apply(profile.ingredients, weightTable?['ingredients']);
      apply(profile.cooking, weightTable?['cooking']);
      apply(profile.stimulus, weightTable?['stimulus']);
    }

    decisionSummary = reasons.isEmpty
        ? '전반적으로 무난한 구성의 식사입니다.'
        : '${reasons.take(3).join(' · ')} 성향이 겹쳐 부담이 될 수 있습니다.';

    setState(() {});
  }

  /* ================= UI ================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('식결')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: birthCtrl,
              decoration: const InputDecoration(
                labelText: '생년월일',
                hintText: '예: 19980427',
              ),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => element = calcElement(v)),
            ),
            const SizedBox(height: 8),
            Text('체질: $element'),

            const SizedBox(height: 16),

            TextField(
              controller: foodCtrl,
              decoration: const InputDecoration(
                labelText: '먹은 음식',
                hintText: '예: 불닭볶음면, 치킨',
              ),
              onChanged: updateSuggestions,
            ),

            if (suggestions.isNotEmpty)
              Wrap(
                spacing: 8,
                children: suggestions.map((s) {
                  return ActionChip(
                    label: Text(s),
                    onPressed: () {
                      foodCtrl.text = s;
                      suggestions.clear();
                      setState(() {});
                    },
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: element.isEmpty || foodCtrl.text.isEmpty
                  ? null
                  : evaluate,
              child: const Text('오늘 식사 평가'),
            ),

            const Divider(height: 32),

            if (decisionSummary.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    decisionSummary,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 8),
            Text('점수: $score점'),

            const Spacer(),

            const Text(
              '※ 본 앱은 생활 리듬 참고용이며\n의학·영양 처방이 아닙니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

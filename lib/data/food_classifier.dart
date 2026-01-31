class FoodProfile {
  final List<String> ingredients;
  final List<String> cooking;
  final List<String> stimulus;

  FoodProfile({
    required this.ingredients,
    required this.cooking,
    required this.stimulus,
  });
}

/* ===== 자동완성 & 분류 키워드 ===== */

const List<String> allFoodKeywords = [
  '라면','불닭볶음면','짜파게티','치킨','삼겹살','김치찌개','된장찌개',
  '비빔밥','김밥','떡볶이','마라탕','마라샹궈','냉면','칼국수',
  '피자','햄버거','돈가스','국밥','설렁탕','갈비탕',
  '샐러드','회','초밥','죽','백숙','콩나물국','미역국'
];

const Map<String, List<String>> ingredientKeywords = {
  '밀가루': ['라면','면','국수','짜장','짬뽕','빵','피자'],
  '쌀': ['밥','김밥','비빔밥','죽','국밥'],
  '돼지고기': ['삼겹','제육','족발'],
  '닭고기': ['치킨','닭','백숙'],
  '해산물': ['회','생선','오징어','낙지'],
  '채소': ['샐러드','나물','무침'],
};

const Map<String, List<String>> cookingKeywords = {
  '튀김': ['튀김','치킨','돈가스'],
  '볶음': ['볶음','불닭','제육'],
  '국물': ['국','찌개','탕','라면'],
  '생식': ['회','샐러드'],
};

const Map<String, List<String>> stimulusKeywords = {
  '매움': ['매운','불닭','떡볶이','마라'],
  '기름짐': ['튀김','치킨','삼겹'],
  '차가움': ['냉','아이스','빙수','냉면'],
};

/* ===== 분류 엔진 ===== */

FoodProfile classifyFood(String food) {
  final ingredients = <String>[];
  final cooking = <String>[];
  final stimulus = <String>[];

  ingredientKeywords.forEach((k, v) {
    if (v.any((e) => food.contains(e))) ingredients.add(k);
  });
  cookingKeywords.forEach((k, v) {
    if (v.any((e) => food.contains(e))) cooking.add(k);
  });
  stimulusKeywords.forEach((k, v) {
    if (v.any((e) => food.contains(e))) stimulus.add(k);
  });

  return FoodProfile(
    ingredients: ingredients,
    cooking: cooking,
    stimulus: stimulus,
  );
}

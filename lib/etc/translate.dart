import 'package:get/get.dart';

class Language extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'pocket_recipe': 'Pocket Recipe',
          'recipe_search': 'Search',
          'setting': 'setting',
        },
        'ko_KR': {
          'pocket_recipe': '포켓 레시피',
          'recipe_search': '검색',
          'menu': '메뉴',
          'setting': '설정',
          'korean_food': '한식',
          'japanese_food': '일식',
          'chinese_food': '중식',
          'western_food': '양식',
          'pizza': '피자',
          'chicken': '치킨',
          'snack': '분식',
          'dessert': '간식',
        },
      };
}

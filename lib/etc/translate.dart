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
          'recipe_search': '레시피 검색',
          'community': '커뮤니티',
          'setting': '설정',
        },
      };
}

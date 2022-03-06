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
          //title
          'pocket_recipe': '포켓 레시피',

          //page name
          'recipe_search': '검색',
          'menu': '메뉴',
          'setting': '설정',
          'recipe_post': '레시피 등록',

          //menu
          'korean_food': '한식',
          'japanese_food': '일식',
          'chinese_food': '중식',
          'western_food': '양식',
          'pizza': '피자',
          'chicken': '치킨',
          'snack': '분식',
          'dessert': '간식',

          //search input
          'search_hint': '요리명 / 요리재료',
          'search_input_empty': '검색어를 입력해주세요.',

          //recipe post
          'recipe_name': '레시피 이름',
          'recipe_cal': '열량(kcal)',
          'recipe_nat': '나트륨(mg)',
          'recipe_car': '탄수화물(g)',
          'recipe_fat': '지방(g)',
          'recipe_pro': '단백질(g)',
          'recipe_img': '이미지 업로드',

          //button
          'next': '다음',
          'prev': '이전',
          'post': '등록',
          'manual_add': '메뉴얼 추가',
          'manual_sub': '메뉴얼 삭제',

          //sanck bar
          'manual_full': '더 이상 메뉴얼을 추가할 수 없습니다.',
          'manual_empty': '더 이상 메뉴얼을 삭제할 수 없습니다.',

          //manual item
          'manual_item_hint': '메뉴얼 설명(100자 이내)',

          //information
          'info': '알림',
        },
      };
}




class Recipe{
  String name = 'Unknown';
  String recipeImg = 'Unknown';
  String parts = 'Unknown';

  String energy = '0';
  String natrium = '0';
  String carbohydrate = '0';
  String fat = '0';
  String protein = '0';
  String author = 'Unknown';

  List<dynamic> imageList = [];
  List<dynamic> manualList = [];

  //0 : 공공데이터 -> 좋아요 없음
  //1 : 좋아요 눌림
  //2 : 좋아요 안눌림
  int isFavorite;
  bool isDelete;
  bool isUpdate;

  Recipe({this.name='Unknown', this.recipeImg='Unknown', this.parts='Unknown',
    this.energy='0', this.carbohydrate='0', this.protein='0', this.fat='0', this.natrium='0',
    this.author='Unknown', this.isFavorite=0, this.isDelete=false, this.isUpdate=false});

  void setName(String value) => this.name = value;
  void setImage(String value) => this.recipeImg = value;
  void setParts(String value) => this.parts = value;
  void setEnergy(String value) => this.energy = value;
  void setCal(String value) => this.carbohydrate = value;
  void setPro(String value) => this.protein = value;
  void setFat(String value) => this.fat = value;
  void setNa(String value) => this.natrium = value;
  void setManualList(List<dynamic> value) => this.manualList = value;
  void setImageList(List<dynamic> value) {

    for(int i = 0; i < value.length; i++){
      if(value[i] == "Unknown"){
        imageList.add(value[i]);
      }
      else{
        imageList.add("http://220.86.224.184:12000/image/view?filePath=" + value[i]);
      }
    }
  }


  Map<String, dynamic> toJson(String author){
    return {
      "recipe_name" : name,
      "recipe_image" : recipeImg,
      "recipe_parts" : parts,
      "recipe_energy" : energy,
      "recipe_cal" : carbohydrate,
      "recipe_pro" : protein,
      "recipe_fat" : fat,
      "recipe_nat" : natrium,
      "recipe_manual" : manualList,
      "recipe_manual_image" : imageList,
      "recipe_author" : author,
    };
  }

  factory Recipe.fromJson(dynamic json){
    String imagePath = "http://220.86.224.184:12000/image/view?filePath=";
    return Recipe(
      name: json["recipe_name"] as String,
      recipeImg: json['recipe_image'] == "Unknown" ? "Unknown" : imagePath + json['recipe_image'] as String,
      parts: "",
      energy: json['recipe_eng'].toString(),
      carbohydrate: json['recipe_cal'].toString(),
      protein: json['recipe_pro'].toString(),
      fat: json['recipe_fat'].toString(),
      natrium: json['recipe_nat'].toString(),
      author: json['recipe_author'] as String,
    );
  }
}


class RecipeListJson {
  int count = 0;
  void setCount(int value){this.count = value;}

  List<Recipe> recipeList = [];
  void setRecipeList(List<Recipe> recipeList){this.recipeList = recipeList;}

  Map<String, dynamic> toJson(String author) {
    List<dynamic> jsonList = [];

    for(int i = 0; i < recipeList.length; i++){
      Recipe recipe = recipeList[i];
      Map<String, dynamic> json = recipe.toJson(author);
      jsonList.add(json);
    }

    return {
      "count" : count,
      "recipeList" : jsonList,
    };
  }
}
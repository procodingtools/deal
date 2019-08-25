class CategoryEntity {
  int _id;
  String _label, _img, _labEn, _labAr, _labEs;
  List<CategoryEntity> _subCategory;


  CategoryEntity({Map<String, dynamic> data}){
    if (data != null){
      _id = data['id'];
      _label = data.containsKey("category_slug") ? data["category_slug"] : data['sub_category_slug'];
      _img = data.containsKey("category_image") ? data["category_image"] : data['image'];
      _labEn = data.containsKey("category_en") ? data["category_en"] : data['sub_category_en'];
      _labAr = data.containsKey("category_arabic") ? data["category_arabic"] : data['sub_category_arabic'];
      _labEs = data.containsKey("category_spenish") ? data["category_spenish"] : data['sub_category_spenish'];

      if (data.containsKey("sub_category")){
        _subCategory = List();
        for (final sub in data['sub_category']){
          _subCategory.add(CategoryEntity(data: sub));
        }
      }
    }
  }

  List<CategoryEntity> get subCategory => _subCategory;

  set subCategory(List<CategoryEntity> value) {
    _subCategory = value;
  }

  get labEs => _labEs;

  set labEs(value) {
    _labEs = value;
  }

  get labAr => _labAr;

  set labAr(value) {
    _labAr = value;
  }

  get labEn => _labEn;

  set labEn(value) {
    _labEn = value;
  }

  get img => _img;

  set img(value) {
    _img = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

}
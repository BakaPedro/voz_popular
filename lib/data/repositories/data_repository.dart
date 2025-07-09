import 'package:voz_popular/data/models/category_model.dart';
import 'package:voz_popular/data/models/theme_model.dart';

abstract class DataRepository {
  Future<List<Category>> getCategories();
  Future<List<ThemeModel>> getThemes();
}
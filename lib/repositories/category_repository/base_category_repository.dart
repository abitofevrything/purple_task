import '../../models/models.dart';

abstract class BaseCategoryRepository {
  Future<int> add({required Category category});

  Future<Category> update({required Category category});

  Future<void> remove({required int categoryId});

  void reorder({
    required int oldIndex,
    required int newIndex,
  });

  Future<List<Category>> getCategories();
}

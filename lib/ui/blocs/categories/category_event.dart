sealed class CategoryEvent {
  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {}

class RefreshCategories extends CategoryEvent {}

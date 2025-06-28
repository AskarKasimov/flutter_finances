import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/repositories/category_repository.dart';
import 'package:flutter_finances/ui/blocs/categories/category_event.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) async {
      switch (event) {
        case LoadCategories():
          await _onLoadCategories(event, emit);
          break;
        case RefreshCategories():
          await _onRefreshCategories(event, emit);
          break;
      }
    });
    add(LoadCategories());
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await repository.getAllCategories();
      emit(CategoryLoaded(categories));
    } catch (_) {
      emit(CategoryError('Failed to load categories'));
    }
  }

  Future<void> _onRefreshCategories(
    RefreshCategories event,
    Emitter<CategoryState> emit,
  ) async {
    try {
      final categories = await repository.getAllCategories();
      emit(CategoryLoaded(categories));
    } catch (_) {
      emit(CategoryError('Failed to refresh categories'));
    }
  }
}

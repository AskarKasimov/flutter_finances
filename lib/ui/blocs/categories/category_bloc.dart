import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/domain/usecases/get_all_categories_usecase.dart';
import 'package:flutter_finances/ui/blocs/categories/category_event.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategoriesUseCase getAllCategoriesUseCase;

  CategoryBloc({required this.getAllCategoriesUseCase})
    : super(CategoryInitial()) {
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
      final categories = await getAllCategoriesUseCase();
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
      final categories = await getAllCategoriesUseCase();
      emit(CategoryLoaded(categories));
    } catch (_) {
      emit(CategoryError('Failed to refresh categories'));
    }
  }
}

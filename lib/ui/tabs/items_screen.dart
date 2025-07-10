import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_bloc.dart';
import 'package:flutter_finances/ui/blocs/categories/category_event.dart';
import 'package:flutter_finances/ui/blocs/categories/category_state.dart';
import 'package:flutter_finances/utils/color_utils.dart';
import 'package:string_similarity/string_similarity.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreen();
}

class _ItemsScreen extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои статьи'), centerTitle: true),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CategoryBloc>().add(RefreshCategories());
            },
            child: switch (state) {
              CategoryInitial() || CategoryLoading() => const Center(
                child: CircularProgressIndicator(),
              ),

              final CategoryLoaded categoriesState => Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).inputDecorationTheme.fillColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Поиск по названию...',
                        suffixIcon: Icon(Icons.search, size: 24),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase();
                        });
                      },
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  Expanded(
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: categoriesState.categories
                          .where(
                            (c) => c.name.toLowerCase().contains(_searchQuery),
                          )
                          .length,
                      itemBuilder: (context, index) {
                        final filtered = _searchQuery.isEmpty
                            ? categoriesState.categories
                            : categoriesState.categories.where((c) {
                                final similarity = c.name
                                    .toLowerCase()
                                    .similarityTo(_searchQuery);
                                return similarity > 0.2 ||
                                    c.name.toLowerCase().contains(_searchQuery);
                              }).toList();
                        final category = filtered[index];

                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: generateLightColorFromId(
                                category.id,
                              ),
                              radius: 16,
                              child: Text(
                                category.emoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                            title: Text(category.name),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              final CategoryError errorState => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(errorState.message),
                    ),
                  ),
                ],
              ),
            },
          );
        },
      ),
    );
  }
}

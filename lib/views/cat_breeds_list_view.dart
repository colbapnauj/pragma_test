import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_config.dart';
import '../core/constants/app_routes.dart';
import '../core/utils/debounce.dart' as debounce_util;
import '../data/repositories/cat_breed_repository.dart';
import '../viewmodels/cat_breeds_list_view_model.dart';
import 'widgets/cat_breed_card.dart';

class CatBreedsListView extends StatelessWidget {
  const CatBreedsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatBreedsListViewModel(context.read<CatBreedRepository>())
        ..loadBreeds(),
      child: const _CatBreedsListViewContent(),
    );
  }
}

class _CatBreedsListViewContent extends StatefulWidget {
  const _CatBreedsListViewContent();

  @override
  State<_CatBreedsListViewContent> createState() =>
      _CatBreedsListViewContentState();
}

class _CatBreedsListViewContentState extends State<_CatBreedsListViewContent> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  late debounce_util.Debounce _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _searchDebounce = debounce_util.Debounce(
      duration: AppConfig.searchDebounceDelay,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final viewModel = context.read<CatBreedsListViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - AppConfig.paginationThreshold) {
      viewModel.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CatBreedsListViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breeds'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  textField: true,
                  label: 'Search cat breeds',
                  enabled: true,
                  onTap: () => _searchController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _searchController.text.length,
                  ),
                  child: SearchBar(
                    controller: _searchController,
                    hintText: 'Search breeds...',
                    onChanged: (value) {
                      viewModel.updateSearchQuery(value);
                      _searchDebounce(() {
                        viewModel.performSearch();
                      });
                    },
                    trailing: _searchController.text.isNotEmpty
                        ? [
                            Semantics(
                              button: true,
                              label: 'Clear search',
                              onTap: () {
                                _searchController.clear();
                                _searchDebounce.cancel();
                                viewModel.updateSearchQuery('');
                                setState(() {});
                              },
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchDebounce.cancel();
                                  viewModel.updateSearchQuery('');
                                  setState(() {});
                                },
                              ),
                            ),
                          ]
                        : null,
                  ),
                ),
                if (viewModel.isInSearchMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      viewModel.isSearching
                          ? 'Searching...'
                          : viewModel.breeds.isEmpty
                              ? 'No results found'
                              : 'Results (${viewModel.breeds.length})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(context, viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, CatBreedsListViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage != null && viewModel.breeds.isEmpty) {
      return Center(
        child: Text(
          'Error: ${viewModel.errorMessage}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (viewModel.isSearching && viewModel.breeds.isEmpty) {
      return const SizedBox.shrink();
    }

    if (viewModel.breeds.isEmpty) {
      return const Center(
        child: Text('No breeds found'),
      );
    }

    if (viewModel.isInSearchMode) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: viewModel.breeds.length,
        itemBuilder: (context, index) {
          final breed = viewModel.breeds[index];
          return CatBreedCard(
            breed: breed,
            onMorePressed: () {
              final path = "/home/${AppRoutes.breedDetailPath(breed.id)}";
              final uri = Uri.parse(path).replace(
                queryParameters: {
                  'name': breed.name,
                  'imageUrl': breed.imageUrl,
                },
              );
              context.go(uri.toString());
            },
          );
        },
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () => viewModel.loadBreeds(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: viewModel.breeds.length + (viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.breeds.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final breed = viewModel.breeds[index];
          return CatBreedCard(
            breed: breed,
            onMorePressed: () {
              final path = "/home/${AppRoutes.breedDetailPath(breed.id)}";
              final uri = Uri.parse(path).replace(
                queryParameters: {
                  'name': breed.name,
                  'imageUrl': breed.imageUrl,
                },
              );
              context.go(uri.toString());
            },
          );
        },
      ),
    );
  }
}

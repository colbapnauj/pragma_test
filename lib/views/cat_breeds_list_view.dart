import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../core/network/dio_client.dart';
import '../core/utils/debounce.dart' as debounce_util;
import '../data/repositories/cat_breed_repository_impl.dart';
import '../viewmodels/cat_breeds_list_view_model.dart';
import 'widgets/cat_breed_card.dart';

class CatBreedsListView extends StatefulWidget {
  const CatBreedsListView({super.key});

  @override
  State<CatBreedsListView> createState() => _CatBreedsListViewState();
}

class _CatBreedsListViewState extends State<CatBreedsListView> {
  late CatBreedsListViewModel _viewModel;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  late debounce_util.Debounce _searchDebounce;

  @override
  void initState() {
    super.initState();
    _viewModel = CatBreedsListViewModel(
      CatBreedRepositoryImpl(DioClient.create()),
    );
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _searchDebounce = debounce_util.Debounce(
      duration: const Duration(milliseconds: 800),
    );
    _scrollController.addListener(_onScroll);
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadBreeds();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      _viewModel.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _searchDebounce.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SearchBar(
                  controller: _searchController,
                  hintText: 'Search breeds...',
                  onChanged: (value) {
                    _viewModel.updateSearchQuery(value);
                    _searchDebounce(() {
                      _viewModel.performSearch();
                    });
                  },
                  trailing: _searchController.text.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              _searchDebounce.cancel();
                              _viewModel.updateSearchQuery('');
                              setState(() {});
                            },
                          ),
                        ]
                      : null,
                ),
                if (_viewModel.isInSearchMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _viewModel.isSearching
                          ? 'Searching...'
                          : _viewModel.breeds.isEmpty
                              ? 'No results found'
                              : 'Results (${_viewModel.breeds.length})',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_viewModel.errorMessage != null && _viewModel.breeds.isEmpty) {
      return Center(
        child: Text(
          'Error: ${_viewModel.errorMessage}',
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_viewModel.isSearching && _viewModel.breeds.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_viewModel.breeds.isEmpty) {
      return const Center(
        child: Text('No breeds found'),
      );
    }

    if (_viewModel.isInSearchMode) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _viewModel.breeds.length,
        itemBuilder: (context, index) {
          final breed = _viewModel.breeds[index];
          return CatBreedCard(
            breed: breed,
            onMorePressed: () {
              context.go("/home/${AppRoutes.breedDetailPath(breed.id)}");
            },
          );
        },
      );
    }

    return RefreshIndicator.adaptive(
      onRefresh: () => _viewModel.loadBreeds(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: _viewModel.breeds.length + (_viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _viewModel.breeds.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          final breed = _viewModel.breeds[index];
          return CatBreedCard(
            breed: breed,
            onMorePressed: () {
              context.go("/home/${AppRoutes.breedDetailPath(breed.id)}");
            },
          );
        },
      ),
    );
  }
}

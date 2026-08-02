import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../core/network/dio_client.dart';
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

  @override
  void initState() {
    super.initState();
    _viewModel = CatBreedsListViewModel(
      CatBreedRepositoryImpl(DioClient.create()),
    );
    _scrollController = ScrollController();
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
            child: SearchBar(
              hintText: 'Search breeds...',
              onChanged: (value) {
                // TODO: implementar búsqueda
              },
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

    if (_viewModel.breeds.isEmpty) {
      return const Center(
        child: Text('No breeds found'),
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

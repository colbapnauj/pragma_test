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

  @override
  void initState() {
    super.initState();
    _viewModel = CatBreedsListViewModel(
      CatBreedRepositoryImpl(DioClient.create()),
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadBreeds();
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
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

    if (_viewModel.errorMessage != null) {
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _viewModel.breeds.length,
      itemBuilder: (context, index) {
        final breed = _viewModel.breeds[index];
        return CatBreedCard(
          breed: breed,
          onMorePressed: () {
            context.go(AppRoutes.breedDetailPath(breed.id));
          },
        );
      },
    );
  }
}

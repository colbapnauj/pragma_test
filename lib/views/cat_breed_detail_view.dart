import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/di/service_locator.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';
import '../viewmodels/cat_breed_detail_view_model.dart';

class CatBreedDetailView extends StatefulWidget {
  const CatBreedDetailView({
    super.key,
    required this.breedId,
    this.breedName,
    this.breedImageUrl,
  });

  final String breedId;
  final String? breedName;
  final String? breedImageUrl;

  @override
  State<CatBreedDetailView> createState() => _CatBreedDetailViewState();
}

class _CatBreedDetailViewState extends State<CatBreedDetailView> {
  late CatBreedDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CatBreedDetailViewModel(getIt<CatBreedRepository>());
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadBreed(
      widget.breedId,
      preloadedName: widget.breedName,
      preloadedImageUrl: widget.breedImageUrl,
    );
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
    final breed = _viewModel.breed;

    return Scaffold(
      appBar: AppBar(
        title: Text(breed?.name ?? 'Breed Detail'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: breed == null
            ? const Center(child: Text('Breed not found'))
            : Column(
                children: [
                  Hero(
                    tag: 'breed_${breed.id}',
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      child: breed.imageUrl.isEmpty
                          ? Container(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              child: const Center(
                                child: Text('No image available'),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: breed.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
                                child: const Center(child: Icon(Icons.error)),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: _viewModel.errorMessage != null
                        ? Center(
                            child: Text('Error: ${_viewModel.errorMessage}'),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildDetailsContent(context, breed),
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context, CatBreed breed) {
    if (_viewModel.isLoading) {
      return _buildLoadingContent(context);
    }
    return _buildLoadedContent(context, breed);
  }

  Widget _buildLoadingContent(BuildContext context) {
    return const CircularProgressIndicator();
  }

  Widget _buildLoadedContent(BuildContext context, CatBreed breed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breed.origin.isNotEmpty) ...[
          _buildDetailRow(context, 'Origin', breed.origin),
          const SizedBox(height: 16),
        ],
        if (breed.intelligence > 0) ...[
          _buildDetailRow(context, 'Intelligence', '${breed.intelligence}/5'),
          const SizedBox(height: 16),
        ],
        if (breed.adaptability != null) ...[
          _buildDetailRow(context, 'Adaptability', '${breed.adaptability}/5'),
          const SizedBox(height: 16),
        ],
        if (breed.lifeSpan != null) ...[
          _buildDetailRow(context, 'Life Span', breed.lifeSpan!),
          const SizedBox(height: 16),
        ],
        if (breed.description != null)
          _buildDescription(context, description: breed.description),
      ],
    );
  }

  Widget _buildDescription(BuildContext context, {String? description}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        Text(description ?? '', style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

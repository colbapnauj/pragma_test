import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_config.dart';
import '../data/entities/cat_breed.dart';
import '../data/repositories/cat_breed_repository.dart';
import '../viewmodels/cat_breed_detail_view_model.dart';

class CatBreedDetailView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CatBreedDetailViewModel(context.read<CatBreedRepository>())
        ..loadBreed(
          breedId,
          preloadedName: breedName,
          preloadedImageUrl: breedImageUrl,
        ),
      child: const _CatBreedDetailViewContent(),
    );
  }
}

class _CatBreedDetailViewContent extends StatelessWidget {
  const _CatBreedDetailViewContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CatBreedDetailViewModel>();
    final breed = viewModel.breed;

    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          label: '${breed?.name ?? "Breed Detail"} details',
          child: Text(breed?.name ?? 'Breed Detail'),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: breed == null
            ? const Center(child: Text('Breed not found'))
            : Column(
                children: [
                  Semantics(
                    image: true,
                    label: '${breed.name} breed image',
                    child: Hero(
                      tag: 'breed_${breed.id}',
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * AppConfig.breedDetailImageHeightRatio,
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
                  ),
                  Expanded(
                    child: RefreshIndicator.adaptive(
                      onRefresh: () => viewModel.refresh(),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16.0),
                        child: _buildDetailsContent(context, breed, viewModel),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    CatBreed breed,
    CatBreedDetailViewModel viewModel,
  ) {
    if (viewModel.errorMessage != null) {
      return Center(child: Text('Error: ${viewModel.errorMessage}'));
    }

    if (viewModel.isLoading) {
      return Center(child: const CircularProgressIndicator());
    }
    return _buildLoadedContent(context, breed);
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
          _buildDetailRow(context, 'Intelligence', '${breed.intelligence}'),
          const SizedBox(height: 16),
        ],
        if (breed.adaptability != null) ...[
          _buildDetailRow(context, 'Adaptability', '${breed.adaptability}'),
          const SizedBox(height: 16),
        ],
        if (breed.lifeSpan != null) ...[
          _buildDetailRow(context, 'Life Span', breed.lifeSpan!),
          const SizedBox(height: 16),
        ],
        if (breed.temperament != null) ...[
          _buildDetailRow(context, 'Temperament', breed.temperament!),
          const SizedBox(height: 16),
        ],
        if (breed.description != null)
          _buildDetailRow(context, 'Description', breed.description ?? ''),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Semantics(
      label: '$label: $value',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

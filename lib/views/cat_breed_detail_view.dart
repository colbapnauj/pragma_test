import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/network/dio_client.dart';
import '../data/repositories/cat_breed_repository_impl.dart';
import '../viewmodels/cat_breed_detail_view_model.dart';

class CatBreedDetailView extends StatefulWidget {
  const CatBreedDetailView({super.key, required this.breedId});

  final String breedId;

  @override
  State<CatBreedDetailView> createState() => _CatBreedDetailViewState();
}

class _CatBreedDetailViewState extends State<CatBreedDetailView> {
  late CatBreedDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CatBreedDetailViewModel(
      CatBreedRepositoryImpl(DioClient.create()),
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadBreed(widget.breedId);
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
        child: _viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : _viewModel.errorMessage != null
            ? Center(child: Text('Error: ${_viewModel.errorMessage}'))
            : breed == null
            ? const Center(child: Text('Breed not found'))
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    child: breed.imageUrl.isEmpty
                        ? Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Text('No image available'),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: breed.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Center(child: Icon(Icons.error)),
                            ),
                          ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(context, 'Origin', breed.origin),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'Intelligence',
                            '${breed.intelligence}/5',
                          ),
                          const SizedBox(height: 16),
                          if (breed.adaptability != null)
                            Column(
                              children: [
                                _buildDetailRow(
                                  context,
                                  'Adaptability',
                                  '${breed.adaptability}/5',
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          if (breed.lifeSpan != null)
                            Column(
                              children: [
                                _buildDetailRow(
                                  context,
                                  'Life Span',
                                  breed.lifeSpan!,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          if (breed.description != null) ...[
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              breed.description!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
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

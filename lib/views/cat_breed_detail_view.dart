import 'package:flutter/material.dart';

class CatBreedDetailView extends StatelessWidget {
  const CatBreedDetailView({super.key, required this.breedId});

  final String breedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breed Detail'),
      ),
      body: const Center(
        child: Text('Breed detail placeholder'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../viewmodels/cat_breeds_list_view_model.dart';
import 'widgets/cat_breed_card.dart';

class CatBreedsListView extends StatelessWidget {
  const CatBreedsListView({super.key, this.viewModel});

  final CatBreedsListViewModel? viewModel;

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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                return const CatBreedCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

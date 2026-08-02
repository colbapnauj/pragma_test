import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/entities/cat_breed.dart';
import '../../l10n/app_localizations.dart';

class CatBreedCard extends StatelessWidget {
  const CatBreedCard({
    super.key,
    required this.breed,
    required this.onMorePressed,
  });

  final CatBreed breed;
  final VoidCallback onMorePressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label: l10n.breedCard(breed.name),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      breed.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Semantics(
                    button: true,
                    onTap: onMorePressed,
                    label: l10n.viewDetails,
                    child: TextButton(
                      onPressed: onMorePressed,
                      child: Text(l10n.moreButton),
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              image: true,
              label: '${breed.name} image',
              child: Hero(
                tag: 'breed_${breed.id}',
                child: SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: breed.imageUrl.isEmpty
                      ? Container(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          child: Center(
                            child: Text(
                              'No image available',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Semantics(
                      label: 'Origin: ${breed.origin}',
                      child: Text(
                        breed.origin,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Semantics(
                      label: 'Intelligence: ${breed.intelligence} out of 5',
                      child: Text(
                        '${breed.intelligence}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

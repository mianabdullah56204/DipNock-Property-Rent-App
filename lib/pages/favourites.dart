import 'package:app/providers/favourites_provider.dart';
import 'package:app/utils/listing_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Watch the provider for changes
    final favouriteListings =
        context.watch<FavouritesProvider>().favoriteListings;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(fontFamily: 'SourceSans3'),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1.0,
      ),
      body:
          favouriteListings.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favourites added yet.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        'Tap the heart icon on listings to save them here.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
                itemCount: favouriteListings.length,
                itemBuilder: (context, index) {
                  final listing = favouriteListings[index];
                  return ListingCard(listing: listing);
                },
              ),
    );
  }
}

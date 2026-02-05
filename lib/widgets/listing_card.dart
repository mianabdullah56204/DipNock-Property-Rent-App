import 'package:app/pages/detail_page.dart';
import 'package:app/providers/favourites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingCard extends StatelessWidget {
  final Map<String, dynamic> listing;

  const ListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Note: Provider access moved inside Consumer for efficiency

    final priceFormat =
        'AED ${listing['price']?.toString() ?? 'N/A'} ${listing['priceFrequency'] ?? ''}';
    final imageUrls = listing['imageUrls'] as List<String>? ?? [];
    final firstImage = imageUrls.isNotEmpty ? imageUrls[0] : null;
    final agencyLogo = listing['agencyLogo'] as String?;
    final listingId = listing['id'] as String? ?? '';

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 1.0,
      shadowColor: Colors.grey[200],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to DetailPage, passing the specific listing data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(listing: listing), // Navigate to DetailPage
              ),
            );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: (firstImage != null)
                      ? Image.asset(
                          firstImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: Icon(Icons.broken_image_outlined,
                                color: Colors.grey[400], size: 50),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported_outlined,
                              color: Colors.grey[400], size: 50),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black.withOpacity(0.3),
                    child: Consumer<FavouritesProvider>( // Use Consumer here
                      builder: (context, favProvider, child) {
                        final isCurrentlyFavorite = favProvider.isFavorite(listingId);
                        return IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isCurrentlyFavorite ? Colors.red : Colors.white,
                            size: 18,
                          ),
                          tooltip: isCurrentlyFavorite
                              ? 'Remove from Favourites'
                              : 'Add to Favourites',
                          onPressed: () {
                            // Use read here as we are inside the builder
                            context
                                .read<FavouritesProvider>()
                                .toggleFavorite(listingId);
                          },
                        );
                      },
                    ),
                  ),
                ),
                if (imageUrls.length > 1)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '1/${imageUrls.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'SourceSans3'),
                      ),
                    ),
                  ),
                if (agencyLogo != null)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 2)
                          ]),
                      height: 35,
                      width: 60,
                      child: Image.asset(agencyLogo, fit: BoxFit.contain),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(priceFormat,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSpec(context, Icons.king_bed_outlined,
                          '${listing['beds'] ?? '?'} bed'),
                      _buildSpec(context, Icons.bathtub_outlined,
                          '${listing['baths'] ?? '?'} bath'),
                      _buildSpec(context, Icons.square_foot_outlined,
                          '${listing['sqft'] ?? '?'} sqft'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    listing['title'] ?? 'No Title',
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          listing['location'] ?? 'No Location',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.call_outlined,
                              size: 18, color: theme.primaryColor),
                          label: Text("Call",
                              style:
                                  TextStyle(color: theme.primaryColor, fontFamily: 'SourceSans3')),
                          onPressed: () {
                            /* TODO: Implement Call Action */
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color:
                                    theme.primaryColor.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.chat_bubble_outline,
                              size: 18, color: Colors.white),
                          label: const Text("WhatsApp",
                              style: TextStyle(color: Colors.white, fontFamily: 'SourceSans3')),
                          onPressed: () {
                            /* TODO: Implement WhatsApp Action */
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8)),
                            elevation: 1,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpec(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
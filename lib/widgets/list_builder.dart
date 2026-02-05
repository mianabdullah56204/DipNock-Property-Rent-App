import 'package:app/pages/detail_page.dart';
import 'package:app/pages/listing_page.dart';
import 'package:app/providers/favourites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBuilder extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const ListBuilder({super.key, required this.items, required this.title});

  @override
  State<ListBuilder> createState() => _ListBuilderState();
}

class _ListBuilderState extends State<ListBuilder> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme data

    // Return an empty container if there are no items to display
    if (widget.items.isEmpty) {
      return const SizedBox.shrink(); // Or display a placeholder if preferred
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Header Row (Title + See All Button) ---
        Padding(
          // Consistent horizontal padding, reduced vertical padding
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 8.0,
            top: 16.0,
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title using theme style
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  // Use a prominent theme style
                  fontWeight: FontWeight.w600, // Medium bold
                  color: Colors.black87,
                ),
              ),
              // "See All" TextButton
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Pass necessary info like the category/title to ListingPage
                      builder: (_) => ListingPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: theme.primaryColor, // Use theme color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ), // Minimal padding
                  textStyle: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ), // Consistent text style
                ),
                child: const Text(
                  "See All",
                  style: TextStyle(fontFamily: 'SourceSans3'),
                ),
              ),
            ],
          ),
        ),

        // --- Horizontal List View ---
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              final listingId = item['id'] as String? ?? '';
              final imageUrls = item['imageUrls'] as List<dynamic>? ?? [];
              final price = item['price'] != null ? 'AED ${item['price']}' : '';
              final specs =
                  '${item['beds']} beds • ${item['baths']} baths • ${item['sqft']}ft';
              final location = item['location'].toString();
              final shortLocation = location.length > 20
                  ? '${location.substring(0, 20)}...'
                  : location;
              final PageController imagePageController = PageController();
              final favouritesProvider =
                  Provider.of<FavouritesProvider>(context);
              final isFavorite = favouritesProvider.isFavorite(listingId);

              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailPage(listing: item)),
                    );
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shadowColor: Colors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image carousel
                        SizedBox(
                          height: 110,
                          child: imageUrls.isNotEmpty
                              ? PageView.builder(
                                  controller: imagePageController,
                                  itemCount: imageUrls.length,
                                  itemBuilder: (context, imageIndex) {
                                    final imageUrl = imageUrls[imageIndex];
                                    return Image.asset(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image_outlined,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Price
                              Text(
                                price,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                  fontFamily: 'SourceSans3',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),

                              // Specs
                              Text(
                                specs,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black87,
                                    fontFamily: 'SourceSans3',
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Location
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      shortLocation,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        // Action buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.call, size: 18),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.chat, size: 18),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.black,
                                  size: 18,
                                ),
                                onPressed: () {
                                  favouritesProvider.toggleFavorite(listingId);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.share, size: 18),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

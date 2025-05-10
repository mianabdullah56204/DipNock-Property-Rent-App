import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:app/providers/favourites_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> listing;

  const DetailPage({super.key, required this.listing});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final PageController _imagePageController = PageController();

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final listing = widget.listing; // Access listing data

    // Safely access data
    final listingId = listing['id'] as String? ?? '';
    final imageUrls = listing['imageUrls'] as List<String>? ?? [];
    final agencyLogo = listing['agencyLogo'] as String?;
    final priceFormat =
        'AED ${listing['price']?.toString() ?? 'N/A'} ${listing['priceFrequency'] ?? ''}';
    final location = listing['location'] ?? 'No Location';
    final title = listing['title'] ?? 'No Title';
    // Add other details you might have
    final propertyType = listing['type'] ?? 'Apartment'; // Example detail
    final purpose = listing['purpose'] ?? 'Rent'; // Example detail
    final description = listing['description'] ?? // Example long description
        'Golden Offer Specious 1Bhk Apartment With Balcony And Sunlighted Cheap Price Only 24K. Contact us for more details and viewing arrangements.';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0, // No shadow
        foregroundColor:
            Colors.white, // Back button color for contrast on image
        leading: Padding(
          // Add padding/background to back button for visibility
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.4),
            child: BackButton(color: Colors.white),
          ),
        ),
        actions: [
          // Favorite Button
          if (listingId.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black.withOpacity(0.4),
                child: Consumer<FavouritesProvider>(
                  builder: (context, favProvider, child) {
                    final isCurrentlyFavorite = favProvider.isFavorite(
                      listingId,
                    );
                    return IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        isCurrentlyFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isCurrentlyFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                      tooltip: isCurrentlyFavorite
                          ? 'Remove from Favourites'
                          : 'Add to Favourites',
                      onPressed: () {
                        context.read<FavouritesProvider>().toggleFavorite(
                              listingId,
                            );
                      },
                    );
                  },
                ),
              ),
            ),
          // Share Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                tooltip: 'Share Listing',
                onPressed: () {
                  // TODO: Implement share functionality
                  print('Share button pressed for $listingId');
                  // Example: Share.share('Check out this listing: $listingUrl');
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // padding: EdgeInsets.zero, // No padding for the scroll view itself
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image Carousel Section ---
            Stack(
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: imageUrls.isNotEmpty
                      ? PageView.builder(
                          controller: _imagePageController,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) {
                            final url = imageUrls[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => FullScreenImageViewer(
                                      imageUrls: imageUrls,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: url,
                                child: Image.asset(
                                  url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[200],
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      color: Colors.grey[400],
                                      size: 60,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 60,
                          ),
                        ),
                ),
                // Agency Logo Overlay (unchanged)
                if (agencyLogo != null)
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      height: 40,
                      width: 70,
                      child: Image.asset(
                        agencyLogo,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
                    ),
                  ),
                // Page Indicator (unchanged)
                if (imageUrls.length > 1)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _imagePageController,
                        count: imageUrls.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: theme.primaryColor,
                          dotColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // --- Details Section Below Image ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Text(
                    priceFormat,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Specs Row
                  Row(
                    children: [
                      _buildSpec(
                        context,
                        Icons.king_bed_outlined,
                        '${listing['beds'] ?? '?'} bed',
                      ),
                      _buildSpec(
                        context,
                        Icons.bathtub_outlined,
                        '${listing['baths'] ?? '?'} bath',
                      ),
                      _buildSpec(
                        context,
                        Icons.square_foot_outlined,
                        '${listing['sqft'] ?? '?'} sqft',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 18,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          location,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[800],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]), // Separator
                  const SizedBox(height: 20),

                  // Title
                  Text(title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                      height: 1.5,
                    ), // Line height
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 20),

                  // Key Details Section
                  Text("Details", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _buildDetailRow(context, "Type", propertyType),
                  _buildDetailRow(context, "Purpose", purpose),
                  const SizedBox(height: 30), // Space before bottom buttons
                ],
              ),
            ),
          ],
        ),
      ),
      // --- Bottom Action Buttons ---
      bottomNavigationBar: _buildBottomActionBar(context),
    );
  }

  // Helper for Spec Items
  Widget _buildSpec(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0), // More space between specs
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  // Helper for Key-Value Detail Rows
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Helper for Bottom Action Bar
  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        16,
      ), // Padding including bottom safe area
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Email Button
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.email_outlined,
                size: 20,
                color: theme.primaryColor,
              ),
              label: Text("Email", style: TextStyle(color: theme.primaryColor)),
              onPressed: () {
                /* TODO: Implement Email Action */
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ), // Adjust padding
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Call Button
          Expanded(
            child: OutlinedButton.icon(
              icon: Icon(
                Icons.call_outlined,
                size: 20,
                color: theme.primaryColor,
              ),
              label: Text("Call", style: TextStyle(color: theme.primaryColor)),
              onPressed: () {
                /* TODO: Implement Call Action */
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // WhatsApp Button
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.chat_bubble_outline,
                size: 20,
                color: Colors.white,
              ), // Use WhatsApp icon if available
              label: const Text(
                "WhatsApp",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                /* TODO: Implement WhatsApp Action */
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 1,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
  });

  @override
  _FullScreenImageViewerState createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(color: Colors.white),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (idx) => setState(() => _currentIndex = idx),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: AssetImage(widget.imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.imageUrls[index],
                ),
              );
            },
            loadingBuilder: (context, progress) => Center(
              child: CircularProgressIndicator(
                value: progress == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                        (progress.expectedTotalBytes ?? 1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '${_currentIndex + 1} / ${widget.imageUrls.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/listing_card.dart'; // Adjust import path if needed
import 'package:app/pages/detail_page.dart';
import 'package:intl/intl.dart'; // For formatting currency

// --- Keep dummyListings accessible if needed as a fallback ---
// But primarily rely on the list passed via constructor
const List<Map<String, dynamic>> localDummyListings = [
 { 'id': '1', 'imageUrls': ['assets/appartment_1.jpg', 'assets/appartment_2.jpg'], 'price': 23990, 'priceFrequency': 'Yearly', 'beds': 1, 'baths': 1, 'sqft': 1000, 'title': 'Golden Offer Specious 1Bhk Apartment Wi...', 'location': 'Al Qasimia, Sharjah', 'agencyLogo': 'assets/agency_logo.png', 'isFavorite': false, 'description': 'Detailed description for listing 1...', 'type': 'Apartment', 'purpose': 'Rent'},
 { 'id': '2', 'imageUrls': ['assets/appartment_2.jpg'], 'price': 35000, 'priceFrequency': 'Yearly', 'beds': 2, 'baths': 2, 'sqft': 1250, 'title': 'Modern 2 Bedroom Apt with Balcony', 'location': 'Al Majaz, Sharjah', 'agencyLogo': 'assets/agency_logo_2.png', 'isFavorite': true, 'description': 'Detailed description for listing 2...', 'type': 'Apartment', 'purpose': 'Rent'},
 { 'id': '3', 'imageUrls': ['assets/villa_1.jpg'], 'price': 120000, 'priceFrequency': 'Yearly', 'beds': 4, 'baths': 5, 'sqft': 3500, 'title': 'Spacious 4 Bed Villa with Garden', 'location': 'Al Rahmaniya, Sharjah', 'agencyLogo': null, 'isFavorite': false, 'description': 'Detailed description for listing 3...', 'type': 'Villa', 'purpose': 'Rent'},
 { 'id': '4', 'imageUrls': ['assets/villa_2.jpg'], 'price': 85000, 'priceFrequency': 'Yearly', 'beds': 3, 'baths': 3, 'sqft': 2800, 'title': 'Family Villa near Park', 'location': 'Al Rahmaniya, Sharjah', 'agencyLogo': 'assets/agency_logo.png', 'isFavorite': false, 'description': 'Detailed description for listing 4...', 'type': 'Villa', 'purpose': 'Rent'},
 // --- Add the listings from the previous 'Buy' page example if they are relevant ---
  {
    'id': 'v1',
    'imageUrls': ['assets/villa_1.jpg','assets/villa_2.jpg','assets/villa_3.jpg'],
    'price': 900000,
    'priceFrequency': 'One-time',
    'beds': 5,
    'baths': 6,
    'sqft': 3500,
    'title': 'Luxury Villa with Pool',
    'location': 'Jumeirah', // Different location example
    'agencyLogo': 'assets/agency_logo.png',
    'isFavorite': false,
    'description':
        'Experience luxury living in this stunning villa featuring a private pool, modern amenities, and expansive outdoor spaces ideal for entertaining.',
    'type': 'Villa',
    'purpose': 'Sale', // Different purpose example
  },
  {
    'id': 'a1',
    'imageUrls': [
      'assets/appartment_1.jpg',
      'assets/appartment_2.jpg',
      'assets/appartment_3.jpg'
    ],
    'price': 450000,
    'priceFrequency': 'One-time',
    'beds': 2,
    'baths': 3,
    'sqft': 1000,
    'title': 'Downtown Apartment View',
    'location': 'Downtown', // Different location example
    'agencyLogo': 'assets/agency_logo.png',
    'isFavorite': false,
    'description':
        'A stylish apartment in the heart of Downtown with panoramic views, modern finishes, and easy access to city amenities.',
    'type': 'Apartment',
    'purpose': 'Sale',
  },
  // Add other listings from 'Buy.dart' if needed for testing
];

class ListingPage extends StatefulWidget {
  // --- MODIFIED: Accept filters and full list ---
  final Map<String, dynamic>? appliedFilters; // Nullable if accessed directly
  final List<Map<String, dynamic>>? allListings; // Nullable for flexibility

  // Keep initialSearchQuery if direct search access is still needed
  final String? initialSearchQuery;

  const ListingPage({
    super.key,
    this.appliedFilters,
    this.allListings,
    this.initialSearchQuery,
  });

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  late final TextEditingController _searchController;
  List<Map<String, dynamic>> _filteredListings = [];
  final NumberFormat _currencyFormat = NumberFormat.currency(symbol: 'AED ', decimalDigits: 0);

  // Use passed list or fallback to local one
  List<Map<String, dynamic>> get _sourceList => widget.allListings ?? localDummyListings;
  // Use passed filters or an empty map
  Map<String, dynamic> get _filters => widget.appliedFilters ?? {};


  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearchQuery);
    // Initial combined filter operation
    _applyAllFilters();
    // Add listener to re-filter when search text changes
    _searchController.addListener(_applyAllFilters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_applyAllFilters);
    _searchController.dispose();
    super.dispose();
  }

  // --- COMBINED Filtering Logic ---
  void _applyAllFilters() {
    List<Map<String, dynamic>> results = List.from(_sourceList); // Start with source

    // 1. Apply structured filters from _filters (passed via constructor)
    _filters.forEach((key, value) {
      if (value == null || (value is String && value.isEmpty)) return;

      switch (key) {
        case 'purpose':
          results = results
              .where((listing) =>
                  listing['purpose']?.toString().toLowerCase() == value.toString().toLowerCase())
              .toList();
          break;
        case 'type':
          results = results
              .where((listing) =>
                  listing['type']?.toString().toLowerCase() == value.toString().toLowerCase())
              .toList();
          break;
        case 'location':
          if (value is List<String>) {
             results = results
                 .where((listing) => value.contains(listing['location']))
                 .toList();
          } else {
             results = results
                 .where((listing) =>
                     listing['location']?.toString().toLowerCase() == value.toString().toLowerCase())
                 .toList();
          }
           break;
        case 'minPrice':
          final minPrice = double.tryParse(value.toString());
          if (minPrice != null) {
            results = results
                .where((listing) => (listing['price'] as num? ?? 0) >= minPrice)
                .toList();
          }
          break;
        case 'maxPrice':
          final maxPrice = double.tryParse(value.toString());
          if (maxPrice != null && maxPrice > 0) {
            results = results
                .where((listing) => (listing['price'] as num? ?? 0) <= maxPrice)
                .toList();
          }
          break;
        case 'beds':
           if (value.toString().toLowerCase() == 'studio') {
               results = results
                   .where((listing) => (listing['beds'] as num? ?? -1) == 0)
                   .toList();
           } else {
               final beds = int.tryParse(value.toString());
               if (beds != null) {
                   results = results
                       .where((listing) => (listing['beds'] as num? ?? -1) == beds)
                       .toList();
               }
           }
          break;
         case 'baths':
           final baths = int.tryParse(value.toString());
           if (baths != null) {
             results = results
                 .where((listing) => (listing['baths'] as num? ?? -1) >= baths)
                 .toList();
           }
           break;
        // Add other filter cases (sqft, amenities, etc.)
      }
    });

    // 2. Apply text search on the already filtered results
    final query = _searchController.text.toLowerCase().trim();
    if (query.isNotEmpty) {
      results = results.where((listing) {
        final title = listing['title']?.toLowerCase() ?? '';
        final location = listing['location']?.toLowerCase() ?? '';
        // Add more fields to search if needed (e.g., description)
        // final description = listing['description']?.toLowerCase() ?? '';
        return title.contains(query) || location.contains(query);
      }).toList();
    }

    // Update state only if the list content has actually changed
    if (!listEquals(_filteredListings, results)) {
      setState(() {
        _filteredListings = results;
      });
    }
  }

  // --- Helper to build filter chips (from previous response) ---
  Widget _buildAppliedFilterChips() {
    List<Widget> chips = [];

    String formatFilterValue(String key, dynamic value) {
      if (value == null) return '';
      switch(key) {
        case 'minPrice':
        case 'maxPrice':
          final price = double.tryParse(value.toString());
          return price != null ? _currencyFormat.format(price) : value.toString();
        case 'beds':
          return value.toString() == '0' ? 'Studio' : '$value Beds';
        case 'baths':
          return '$value Baths';
        default:
          return value.toString();
      }
    }

    String formatFilterKey(String key) {
      switch(key) {
        case 'minPrice': return 'Min Price';
        case 'maxPrice': return 'Max Price';
        case 'type': return 'Type';
        case 'purpose': return 'Purpose';
        case 'location': return 'Location';
        case 'beds': return 'Beds';
        case 'baths': return 'Baths';
        default: return key;
      }
    }

    _filters.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        chips.add(
          Chip(
            label: Text(
              '${formatFilterKey(key)}: ${formatFilterValue(key, value)}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700], fontFamily: 'SourceSans3'),
            ),
            backgroundColor: Colors.grey[200],
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Make chip smaller
             visualDensity: VisualDensity.compact, // Make chip denser
          ),
        );
      }
    });

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    // Use SingleChildScrollView for horizontal scroll if chips might overflow
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0, top: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 8.0, // Horizontal space between chips
          // runSpacing: 4.0, // Vertical space (not needed for horizontal scroll)
          children: chips,
        ),
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87, // Color for back button, etc.
        elevation: 1.0,
        titleSpacing: 0, // Adjust spacing if needed
        // --- MODIFIED: Use a simple title or result count ---
        title: Text(
           '${_filteredListings.length} Results',
           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'SourceSans3'),
         ),
         centerTitle: false, // Keep title left-aligned
        // --- MODIFIED: Use 'bottom' for Search and Chips ---
        bottom: PreferredSize(
           preferredSize: Size.fromHeight( _filters.isNotEmpty ? 100 : 55), // Adjust height: more space needed if chips are present
           child: Column(
             mainAxisSize: MainAxisSize.min, // Crucial for Column height
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // --- Search Bar ---
               Padding(
                 padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                 child: SizedBox(
                   height: 40,
                   child: TextField(
                     controller: _searchController,
                     // autofocus: widget.initialSearchQuery != null && widget.initialSearchQuery!.isNotEmpty, // Maybe disable autofocus
                     decoration: InputDecoration(
                       hintText: 'Search Location or Title...',
                       hintStyle: TextStyle(color: Colors.grey[600], fontSize: 15, fontFamily: 'SourceSans3'),
                       prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey[600]),
                       contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                       filled: true,
                       fillColor: Colors.grey[100], // Slightly lighter fill
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8.0),
                         borderSide: BorderSide.none,
                       ),
                       enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8.0),
                         borderSide: BorderSide.none,
                       ),
                       focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(8.0),
                         borderSide: BorderSide(color: theme.primaryColor.withOpacity(0.7), width: 1.0),
                       ),
                       suffixIcon: _searchController.text.isNotEmpty
                           ? IconButton(
                               icon: Icon(Icons.clear, size: 18, color: Colors.grey[600]),
                               tooltip: 'Clear search',
                               onPressed: () {
                                 _searchController.clear();
                                 // _applyAllFilters will be called by the listener
                               },
                             )
                           : null,
                     ),
                     style: theme.textTheme.bodyLarge?.copyWith(fontSize: 15),
                   ),
                 ),
               ),
               // --- Applied Filter Chips ---
               _buildAppliedFilterChips(),
             ],
           ),
         ),
      ),
      body: _filteredListings.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  // Provide a more informative message based on filters/search
                  _searchController.text.isEmpty && _filters.isEmpty
                      ? 'No listings available.'
                      : 'No listings found matching your criteria.',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
              )
            )
          : ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
              itemCount: _filteredListings.length,
              itemBuilder: (context, index) {
                final listing = _filteredListings[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(listing: listing),
                      ),
                    );
                  },
                  child: ListingCard(
                    listing: listing,
                  ),
                );
              },
            ),
    );
  }
}
import 'package:flutter/material.dart';

const List<Map<String, dynamic>> dummyListings = [
  {
    'id': '1',
    'imageUrls': ['assets/appartment_1.jpg', 'assets/appartment_2.jpg'],
    'price': 23990,
    'priceFrequency': 'Yearly',
    'beds': 1,
    'baths': 1,
    'sqft': 1000,
    'title': 'Golden Offer Specious 1Bhk Apartment Wi...',
    'location': 'Al Qasimia, Sharjah',
    'agencyLogo': 'assets/agency_logo.png',
    'isFavorite': false,
  },
  {
    'id': '2',
    'imageUrls': ['assets/appartment_2.jpg'],
    'price': 35000,
    'priceFrequency': 'Yearly',
    'beds': 2,
    'baths': 2,
    'sqft': 1250,
    'title': 'Modern 2 Bedroom Apt with Balcony',
    'location': 'Al Majaz, Sharjah',
    'agencyLogo': 'assets/agency_logo_2.png',
    'isFavorite': true,
  },
  {
    'id': '3',
    'imageUrls': ['assets/villa_1.jpg'],
    'price': 120000,
    'priceFrequency': 'Yearly',
    'beds': 4,
    'baths': 5,
    'sqft': 3500,
    'title': 'Spacious 4 Bed Villa with Garden',
    'location': 'Al Rahmaniya, Sharjah',
    'agencyLogo': null,
    'isFavorite': false,
  },
  {
    'id': '4',
    'imageUrls': ['assets/villa_2.jpg'],
    'price': 85000,
    'priceFrequency': 'Yearly',
    'beds': 3,
    'baths': 3,
    'sqft': 2800,
    'title': 'Family Villa near Park',
    'location': 'Al Rahmaniya, Sharjah',
    'agencyLogo': 'assets/agency_logo.png',
    'isFavorite': false,
  },
];

class FavouritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => Set.unmodifiable(_favoriteIds);

  // Getter to return the full listing objects that are favorites
  List<Map<String, dynamic>> get favoriteListings {
    return dummyListings.where((listing) => _favoriteIds.contains(listing['id'])).toList();
  }

  // Check if a specific listing is a favorite
  bool isFavorite(String listingId) {
    return _favoriteIds.contains(listingId);
  }

  // Toggle favorite status for a listing
  void toggleFavorite(String listingId) {
    if (_favoriteIds.contains(listingId)) {
      _favoriteIds.remove(listingId);
    } else {
      _favoriteIds.add(listingId);
    }
    notifyListeners();
    // Optional: Add persistence logic here
  }

  // --- Initial Setup ---
  void initializeFavorites() {
    for (var listing in dummyListings) {
      if (listing['isFavorite'] == true) {
        _favoriteIds.add(listing['id']);
      }
    }
  }

  // Constructor
  FavouritesProvider() {
    initializeFavorites();
  }
}
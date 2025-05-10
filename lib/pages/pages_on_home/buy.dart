import 'dart:async';
import 'package:app/pages/favourites.dart';
import 'package:app/pages/listing_page.dart';
import 'package:app/utils/filter_page.dart';
import 'package:app/utils/list_builder.dart';
import 'package:app/utils/property_card.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class Buy extends StatefulWidget {
  const Buy({super.key});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  String selectedCity = "All Cities";
  final List<String> cities = [
    "All Cities",
    "Jumeirah",
    "Palm Jumeirah",
    "Emirates Hills",
    "Downtown",
    "Dubai Marina",
    "Business Bay",
    "JLT",
    "Dubai Mall Area",
  ];

  final List<Map<String, dynamic>> dummyListings = [
    {
      'id': 'v1',
      'imageUrls': [
        'assets/villa_1.jpg',
        'assets/villa_2.jpg',
        'assets/villa_3.jpg',
      ],
      'price': 900000,
      'priceFrequency': 'One-time',
      'beds': 5,
      'baths': 6,
      'sqft': 3500,
      'title': 'Luxury Villa with Pool',
      'location': 'Jumeirah',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'Experience luxury living in this stunning villa featuring a private pool, modern amenities, and expansive outdoor spaces ideal for entertaining.',
      'type': 'Villa',
      'purpose': 'Sale',
    },
    {
      'id': 'v2',
      'imageUrls': [
        'assets/villa_1.jpg',
        'assets/villa_2.jpg',
        'assets/villa_3.jpg',
      ],
      'price': 1250000,
      'priceFrequency': 'One-time',
      'beds': 6,
      'baths': 7,
      'sqft': 4000,
      'title': 'Modern Villa on Palm',
      'location': 'Palm Jumeirah',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'This contemporary villa offers breathtaking views, sleek design, and premium finishes, perfectly situated on Palm Jumeirah.',
      'type': 'Villa',
      'purpose': 'Sale',
    },
    {
      'id': 'v3',
      'imageUrls': [
        'assets/villa_1.jpg',
        'assets/villa_2.jpg',
        'assets/villa_3.jpg',
      ],
      'price': 850000,
      'priceFrequency': 'One-time',
      'beds': 4,
      'baths': 5,
      'sqft': 3000,
      'title': 'Family Villa Emirates Hills',
      'location': 'Emirates Hills',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A perfect family home with elegant interiors, a spacious garden, and a prime location in the exclusive Emirates Hills.',
      'type': 'Villa',
      'purpose': 'Sale',
    },
    // Apartments
    {
      'id': 'a1',
      'imageUrls': [
        'assets/appartment_1.jpg',
        'assets/appartment_2.jpg',
        'assets/appartment_3.jpg',
      ],
      'price': 450000,
      'priceFrequency': 'One-time',
      'beds': 2,
      'baths': 3,
      'sqft': 1000,
      'title': 'Downtown Apartment View',
      'location': 'Downtown',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A stylish apartment in the heart of Downtown with panoramic views, modern finishes, and easy access to city amenities.',
      'type': 'Apartment',
      'purpose': 'Sale',
    },
    {
      'id': 'a2',
      'imageUrls': [
        'assets/appartment_1.jpg',
        'assets/appartment_2.jpg',
        'assets/appartment_3.jpg',
      ],
      'price': 600000,
      'priceFrequency': 'One-time',
      'beds': 3,
      'baths': 3,
      'sqft': 1100,
      'title': 'Marina View Apartment',
      'location': 'Dubai Marina',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'Enjoy stunning marina views from this modern apartment that blends comfort with luxurious living in a vibrant community.',
      'type': 'Apartment',
      'purpose': 'Sale',
    },
    {
      'id': 'a3',
      'imageUrls': [
        'assets/appartment_1.jpg',
        'assets/appartment_2.jpg',
        'assets/appartment_3.jpg',
      ],
      'price': 380000,
      'priceFrequency': 'One-time',
      'beds': 1,
      'baths': 2,
      'sqft': 800,
      'title': 'Cozy JLT Apartment',
      'location': 'JLT',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A cozy and efficient apartment in JLT, ideal for singles or couples looking for modern urban living at an affordable price.',
      'type': 'Apartment',
      'purpose': 'Sale',
    },
    // Shops
    {
      'id': 's1',
      'imageUrls': [
        'assets/shop_1.jpg',
        'assets/shop_2.jpg',
        'assets/shop_3.jpg',
      ],
      'price': 1500000,
      'priceFrequency': 'One-time',
      'beds':
          0, // Shops/Offices might not have beds/baths, handle filtering accordingly
      'baths': 0,
      'sqft': 1500,
      'title': 'Retail Shop Prime Location',
      'location': 'Business Bay',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A prime retail shop in Business Bay offering high visibility and excellent foot traffic, ideal for upscale retail operations.',
      'type': 'Shop',
      'purpose': 'Sale',
    },
    {
      'id': 's2',
      'imageUrls': [
        'assets/shop_1.jpg',
        'assets/shop_2.jpg',
        'assets/shop_3.jpg',
      ],
      'price': 950000,
      'priceFrequency': 'One-time',
      'beds': 0,
      'baths': 0,
      'sqft': 1200,
      'title': 'High Street Shop Front',
      'location': 'Downtown',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'Located on a bustling high street, this shop front offers a modern facade and ample space for various retail concepts.',
      'type': 'Shop',
      'purpose': 'Sale',
    },
    {
      'id': 's3',
      'imageUrls': [
        'assets/shop_1.jpg',
        'assets/shop_2.jpg',
        'assets/shop_3.jpg',
      ],
      'price': 2100000,
      'priceFrequency': 'One-time',
      'beds': 0,
      'baths': 0,
      'sqft': 2500,
      'title': 'Large Shop in Mall',
      'location': 'Dubai Mall Area',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'An expansive shop located in a premier mall setting, offering an ideal space for flagship retail operations.',
      'type': 'Shop',
      'purpose': 'Sale',
    },
    // Offices
    {
      'id': 'o1',
      'imageUrls': [
        'assets/office_1.jpg',
        'assets/office_2.jpg',
        'assets/office_3.jpg',
      ],
      'price': 700000,
      'priceFrequency': 'One-time', // Assuming sale, adjust if rent
      'beds': 0,
      'baths': 0,
      'sqft': 1000,
      'title': 'Fitted Office Space',
      'location': 'JLT',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A fully fitted office space in JLT, designed for modern businesses with a productive layout and professional ambience.',
      'type': 'Office',
      'purpose': 'Rent', // Example purpose, adjust filters based on this
    },
    {
      'id': 'o2',
      'imageUrls': [
        'assets/office_1.jpg',
        'assets/office_2.jpg',
        'assets/office_3.jpg',
      ],
      'price': 1100000,
      'priceFrequency': 'One-time',
      'beds': 0,
      'baths': 0,
      'sqft': 5000,
      'title': 'Full Floor Office',
      'location': 'Business Bay',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'This full-floor office in Business Bay provides expansive open-plan design and state-of-the-art facilities, perfect for corporate headquarters.',
      'type': 'Office',
      'purpose': 'Rent',
    },
    {
      'id': 'o3',
      'imageUrls': [
        'assets/office_1.jpg',
        'assets/office_2.jpg',
        'assets/office_3.jpg',
      ],
      'price': 850000,
      'priceFrequency': 'One-time',
      'beds': 0,
      'baths': 0,
      'sqft': 800,
      'title': 'Serviced Office Downtown',
      'location': 'Downtown',
      'agencyLogo': 'assets/agency_logo.png',
      'isFavorite': false,
      'description':
          'A serviced office space in Downtown offering flexible lease terms, modern facilities, and a dynamic work environment.',
      'type': 'Office',
      'purpose': 'Rent',
    },
  ];

  // --- MODIFIED: Make _openFilterPanel async ---
  Future<void> _openFilterPanel({String? initialPurpose}) async {
    // --- MODIFIED: Await the result and store it ---
    final Map<String, dynamic>? appliedFilters =
        await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (_, controller) => Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black54),
                      onPressed: () => Navigator.pop(
                        sheetContext,
                      ), // Pop without results
                      tooltip: 'Close Filters',
                    ),
                    const Text(
                      "Filters",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        fontFamily: 'SourceSans3',
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  // --- MODIFIED: Pass initialPurpose to FilterPage if needed ---
                  // Assuming FilterPage constructor accepts initialPurpose
                  child: FilterPage(initialPurpose: initialPurpose),
                  // If FilterPage doesn't need initialPurpose, keep it as:
                  // child: FilterPage(),
                ),
              ),
              // Apply/Reset buttons are INSIDE FilterPage.
              // FilterPage's Apply button should call Navigator.pop(context, collectedFiltersMap);
            ],
          ),
        );
      },
    );

    // --- MODIFIED: Check if filters were applied and navigate ---
    if (appliedFilters != null && appliedFilters.isNotEmpty && mounted) {
      // Check mounted
      // Add the selected city from the app bar if it's not "All Cities"
      // You might want a more robust way to handle location filters
      // if the FilterPage also has location selection. This is a simple example.
      if (selectedCity != "All Cities" &&
          !appliedFilters.containsKey('location')) {
        appliedFilters['location'] = selectedCity;
      }

      // Pass the full list and the filters to ListingPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListingPage(
            appliedFilters: appliedFilters,
            allListings: dummyListings, // Pass the full list
          ),
        ),
      );
    } else {
      // Handle the case where the user closed the sheet without applying filters
      print("Filter sheet closed without applying filters.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. TextStyle used for both button & menu items:
    final itemTextStyle = TextStyle(
      color: Colors.grey[900],
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: 'SorceSans3',
    );

    // 2. Find the longest city name:
    final longestCity = cities.reduce((a, b) => a.length > b.length ? a : b);

    // 3. Measure its width:
    final textPainter = TextPainter(
      text: TextSpan(text: longestCity, style: itemTextStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    // 4. Add horizontal padding + arrow icon + spacing
    final menuWidth = textPainter.size.width +
        12 /*left padding*/ +
        12 /*right padding*/ +
        4 /*gap before arrow*/ +
        20 /*arrow icon width*/;

    return Scaffold(
      backgroundColor: Colors.white, // Light grey background for the main page
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/logo.png', height: 50, width: 100),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton2<String>(
              // ← no underline
              underline: const SizedBox(),

              // ← make the scrim behind the open‑menu transparent
              barrierColor: Colors.transparent,

              isExpanded: true,
              value: selectedCity,

              items: cities
                  .map(
                    (city) => DropdownMenuItem<String>(
                      value: city,
                      child: Text(city, style: itemTextStyle),
                    ),
                  )
                  .toList(),
              onChanged: (newVal) => setState(() => selectedCity = newVal!),

              // ---- style the CLOSED button itself ----
              buttonStyleData: ButtonStyleData(
                // match the menu width so button and menu align
                width: menuWidth,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // ---- arrow icon ----
              iconStyleData: IconStyleData(
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[700]),
                iconSize: 20,
              ),

              // ---- style the OPEN menu ----
              dropdownStyleData: DropdownStyleData(
                width: menuWidth,
                maxHeight: 4 * 48.0 + 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(0, 6),
                scrollbarTheme: ScrollbarThemeData(
                  thickness: WidgetStateProperty.all(6),
                  thumbVisibility: WidgetStateProperty.all(true),
                  radius: const Radius.circular(8),
                ),
              ),

              // ---- each item ----
              menuItemStyleData: const MenuItemStyleData(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8.0),
            child: Row(
              children: [
                // — Simplified Search Bar w/ Animated Placeholder —
                Expanded(
                  flex: 7,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to your real search page
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[600]),
                          const SizedBox(width: 8),

                          // STATIC "Search for"
                          Text(
                            'Search for ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontFamily: 'SorceSans3',
                            ),
                          ),

                          // ANIMATED category word
                          Flexible(
                            child: CategorySwitcher(
                              categories: [
                                'Villas',
                                'Apartments',
                                'Cottages',
                                'Lofts',
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.grey[800]),
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => FavouritesPage()));
                  },
                ),

                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.grey[800]),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications tapped!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align titles to the left
          children: [
            const SizedBox(height: 20), // Space at the top
            // --- Top Category Buttons ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround, // Distribute space
                children: [
                  _buildCategoryCard(
                    context,
                    'Property\nfor Rent',
                    'assets/rent.png',
                    // --- MODIFIED: Pass purpose ---
                    () => _openFilterPanel(initialPurpose: 'Rent'),
                  ),
                  _buildCategoryCard(
                    context,
                    'Property\nfor Sale',
                    'assets/sale.png',
                    // --- MODIFIED: Pass purpose ---
                    () => _openFilterPanel(initialPurpose: 'Sale'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // --- Ad Card ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child:
                  PropertyAdCard(), // Assuming this widget exists and is defined
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListBuilder(
                items: dummyListings
                    .where((listing) => listing['type'] == 'Office')
                    .toList(),
                title: "Popular in Offices",
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListBuilder(
                items: dummyListings
                    .where((listing) => listing['type'] == 'Apartment')
                    .toList(),
                title: "Popular in Apartments",
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListBuilder(
                items: dummyListings
                    .where((listing) => listing['type'] == 'Shop')
                    .toList(),
                title: "Popular in Shops",
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListBuilder(
                items: dummyListings
                    .where((listing) => listing['type'] == 'Villa')
                    .toList(),
                title: "Popular in Villas",
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    String imagePath,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12), // Adjusted padding
        height: 110, // Slightly taller
        width: MediaQuery.of(context).size.width * 0.35, // Responsive width
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 244, 244, 244),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: [
            Image.asset(
              imagePath,
              height: 45, // Slightly larger image
              fit: BoxFit.contain, // Use contain to avoid distortion
              // Optional: Add error builder
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.business, size: 45, color: Colors.grey),
            ),
            const SizedBox(height: 8), // Increased spacing
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11, // Slightly larger font
                fontWeight: FontWeight.w600, // Medium bold
                fontFamily: 'SourceSans3',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySwitcher extends StatefulWidget {
  final List<String> categories;
  final Duration switchInterval;

  const CategorySwitcher({
    super.key,
    required this.categories,
    this.switchInterval = const Duration(seconds: 3),
  });

  @override
  _CategorySwitcherState createState() => _CategorySwitcherState();
}

class _CategorySwitcherState extends State<CategorySwitcher> {
  int _current = 0;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.switchInterval, (_) {
      setState(() => _current = (_current + 1) % widget.categories.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 20,
      child: ClipRect(
        // prevent overflow artifacts
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          layoutBuilder: (currentChild, previousChildren) {
            // ensure only the incoming child is visible until animation finishes
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (child, animation) {
            // use a smaller slide offset (just 10% of height)
            final offsetTween = Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            );
            return SlideTransition(
              position: animation.drive(
                offsetTween.chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: FadeTransition(
                opacity: animation,
                child: Align(alignment: Alignment.centerLeft, child: child),
              ),
            );
          },
          child: Text(
            widget.categories[_current],
            key: ValueKey<int>(_current),
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: 'SourceSans3',
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

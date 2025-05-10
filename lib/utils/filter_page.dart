import 'package:flutter/material.dart';

class FilterPage extends StatelessWidget {
  final String? initialPurpose;
  const FilterPage({super.key, required this.initialPurpose});

  @override
  Widget build(BuildContext context) {
    int initialTabIndex = 0; // Default to 'Rent' (index 0)
    // Check the value passed from Buy page
    if (initialPurpose?.toLowerCase() == 'sale') {
      // Or 'buy' depending on what you passed
      initialTabIndex = 1; // Select the 'Buy' tab (index 1)
    }
    return Scaffold(
      body: DefaultTabController(
        initialIndex: initialTabIndex,
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.grey[900],
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Colors.red,
              indicatorWeight: 3,
              tabs: [Tab(text: 'Rent'), Tab(text: 'Buy')],
            ),
            Expanded(child: TabBarView(children: [FilterBuy(), FilterRent()])),
          ],
        ),
      ),
    );
  }
}

// 1. New Stateful Widget containing the shared form UI and logic
class _FilterFormContent extends StatefulWidget {
  const _FilterFormContent();

  @override
  State<_FilterFormContent> createState() => _FilterFormContentState();
}

// 2. The State class - essentially the previous _FilterBuyState
class _FilterFormContentState extends State<_FilterFormContent> {
  // Inside class _FilterFormContentState...

  void _applyFilters() {
    // 1. Create a clean copy of the filters to return
    final Map<String, dynamic> finalFilters = Map.from(_filters);

    // 2. OPTIONAL BUT RECOMMENDED: Clean up the map
    // Remove entries that are null, empty, or represent default 'Any'/'All' values
    finalFilters.removeWhere((key, value) {
      if (value == null) return true;
      if (value is List && value.isEmpty) return true;
      if (value is Set && value.isEmpty) return true; // Like _selectedBedrooms

      // Remove default ranges (adjust max values if different)
      if (key == 'priceRange' &&
          value is Map &&
          value['min'] == 0 &&
          value['max'] == 1000000) {
        return true;
      }
      if (key == 'areaRange' &&
          value is Map &&
          value['min'] == 0 &&
          value['max'] == 5000) {
        return true;
      }

      // Remove default 'All...' categories
      if (key == 'category' && value == 'All Residential') return true;
      if (key == 'commercialCategory' && value == 'All Commercial') return true;
      if (key == 'roomCategory' && value == 'All Rooms') return true;
      if (key == 'monthlyRentCategory' && value == 'All Monthly Rent') {
        return true;
      }
      if (key == 'dailyRentCategory' && value == 'All Daily Rent') return true;

      // Add more cleanup logic if needed (e.g., empty strings for keywords)
      if (key == 'keyword' && (value as String).isEmpty) return true;
      if (key == 'realEstateAgencies' && (value as String).isEmpty) return true;

      // Check for default boolean flags
      if (key == 'adsInEnglish' && value == false) return true;
      if (key == 'adsWithVideo' && value == false) return true;
      if (key == 'adsWith360Tour' && value == false) return true;

      return false;
    });

    // 3. Pop the modal sheet returning the cleaned filters
    // This assumes 'context' here is the one for the modal sheet environment
    Navigator.pop(context, finalFilters);
  }

  // Inside class _FilterFormContentState...

  void _resetFilters() {
    setState(() {
      // Reset all state variables back to their default values
      _selectedPropertyType = 'Residential'; // Or your default
      // Reset all category selections
      _selectedCategory = null;
      _selectedCommercialCategory = null;
      _selectedRoomCategory = null;
      _selectedMonthlyRentCategory = null;
      _selectedDailyRentCategory = null;

      _selectedBedrooms.clear();
      _selectedBathrooms.clear();

      // Reset Range Sliders and Text Controllers (use your defaults)
      _areaRange = const RangeValues(0, 5000);
      _areaMinController.text = '0';
      _areaMaxController.text = '5000';
      _priceRange = const RangeValues(0, 1000000);
      _priceMinController.text = '0';
      _priceMaxController.text = '1000000';

      _selectedFurnishing = null; // Represents 'All'

      _excludedLocations.clear();
      _excludeLocationController.clear(); // Clear the input field too

      _selectedAmenities.clear();
      _keywordController.clear();
      _listedBy.clear();
      _realEstateAgenciesController.clear();
      _rentPaid = null; // Assuming null is default

      _adsInEnglish = false;
      _adsWithVideo = false;
      _adsWith360Tour = false;

      // Clear the main filters map and re-initialize based on default type
      _filters.clear();
      _initializeFilters(); // This already sets the default category based on _selectedPropertyType
    });
  }

  // --- All the state variables from the original _FilterBuyState ---
  String? _selectedPropertyType = 'Residential';
  String? _selectedCategory = 'All Residential'; // Initial default
  final Set<String> _selectedBedrooms = {};
  final Set<String> _selectedBathrooms = {};
  final TextEditingController _areaMinController = TextEditingController();
  final TextEditingController _areaMaxController = TextEditingController();
  RangeValues _areaRange = const RangeValues(0, 5000);
  final TextEditingController _priceMinController = TextEditingController();
  final TextEditingController _priceMaxController = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 1000000);
  String? _selectedFurnishing; // Defaulting to 'All' logic handled in build
  final Set<String> _excludedLocations = {};
  final Set<String> _selectedAmenities = {};
  final TextEditingController _keywordController = TextEditingController();
  final TextEditingController _excludeLocationController =
      TextEditingController(); // Added controller for exclude input
  final Set<String> _listedBy = {};
  final TextEditingController _realEstateAgenciesController =
      TextEditingController();
  String? _rentPaid;
  bool _adsInEnglish = false;
  bool _adsWithVideo = false;
  bool _adsWith360Tour = false;

  final Map<String, dynamic> _filters = {};

  // --- Property Categories and Options (unchanged) ---
  final Map<String, List<String>> _propertyCategories = {
    'Residential': [
      'All Residential',
      'Apartment',
      'Penthouse',
      'Residential Building',
      'Residential Floor',
      'Townhouse',
      'Villa Compound',
      'Villa',
      'Rooms',
    ],
    'Commercial': [
      // Added commercial categories directly here
      'All Commercial', 'Bulk Unit', 'Commercial Building', 'Commercial Floor',
      'Commercial Plot', 'Commercial Villa', 'Factory', 'Industrial',
      'Industrial Land', 'Mixed Use Land', 'Office', 'other', 'Retail',
      'Shop', 'Showroom', 'Staff Accom', 'Warehouse',
    ],
    'Rooms': ['All Rooms', 'Apartment', 'Villa'], // Added room categories
    'Monthly Rent': [
      'All Monthly Rent',
      'Apartment',
      'Villa',
    ], // Added monthly rent categories
    'Daily Rent': [
      'All Daily Rent',
      'Apartment',
      'Villa',
    ], // Added daily rent categories
  };
  String? _selectedCommercialCategory; // State for Commercial
  String? _selectedRoomCategory; // State for Rooms
  String? _selectedMonthlyRentCategory; // State for Monthly Rent
  String? _selectedDailyRentCategory; // State for Daily Rent

  final List<String> _bedroomOptions = ['Studio', '1', '2', '3', '4', '5+'];
  final List<String> _bathroomOptions = ['1', '2', '3', '4', '5', '6+'];
  final List<String> _furnishingOptions = ['All', 'Furnished', 'Unfurnished'];
  final List<String> _amenitiesOptions = [
    'Maids Room', 'Study', 'Central A/C', 'Heating', 'Balcony',
    'Private Garden', 'Private Pool', 'Security', 'Covered Parking',
    'Built In Wardrobes', // Add more amenities
  ];
  final List<String> _listedByOptions = ['Agency', 'Landlord', 'Developer'];
  final List<String> _rentPaidOptions = [
    'Yearly',
    'Bi-Yearly',
    'Quarterly',
    'Monthly',
  ];

  // --- All the helper methods from _FilterBuyState (unchanged) ---
  @override
  void initState() {
    super.initState();
    // Initialize based on the default _selectedPropertyType
    _initializeFilters();
    _priceMinController.text = _priceRange.start.round().toString();
    _priceMaxController.text = _priceRange.end.round().toString();
    _areaMinController.text = _areaRange.start.round().toString();
    _areaMaxController.text = _areaRange.end.round().toString();
  }

  @override
  void dispose() {
    _areaMinController.dispose();
    _areaMaxController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    _keywordController.dispose();
    _realEstateAgenciesController.dispose();
    _excludeLocationController.dispose();
    super.dispose();
  }

  void _initializeFilters() {
    _filters['propertyType'] = _selectedPropertyType;
    _selectedCategory = null;
    _selectedCommercialCategory = null;
    _selectedRoomCategory = null;
    _selectedMonthlyRentCategory = null;
    _selectedDailyRentCategory = null;
    _filters.remove('category');
    _filters.remove('commercialCategory');
    _filters.remove('roomCategory');
    _filters.remove('monthlyRentCategory');
    _filters.remove('dailyRentCategory');

    if (_selectedPropertyType == 'Residential') {
      _selectedCategory = 'All Residential';
      _filters['category'] = 'All Residential';
    } else if (_selectedPropertyType == 'Commercial') {
      _selectedCommercialCategory = 'All Commercial';
      _filters['commercialCategory'] = 'All Commercial';
    } else if (_selectedPropertyType == 'Rooms') {
      _selectedRoomCategory = 'All Rooms';
      _filters['roomCategory'] = 'All Rooms';
    } else if (_selectedPropertyType == 'Monthly Rent') {
      _selectedMonthlyRentCategory = 'All Monthly Rent';
      _filters['monthlyRentCategory'] = 'All Monthly Rent';
    } else if (_selectedPropertyType == 'Daily Rent') {
      _selectedDailyRentCategory = 'All Daily Rent';
      _filters['dailyRentCategory'] = 'All Daily Rent';
    }
  }

  void _selectPropertyType(String type) {
    setState(() {
      _selectedPropertyType = type;
      _initializeFilters(); // Reset and set initial category filter
    });
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      // Update filters: null if 'All Residential', otherwise the category
      _filters['category'] = category == 'All Residential' ? null : category;
    });
  }

  void _selectCommercialCategory(String category) {
    setState(() {
      _selectedCommercialCategory = category;
      _filters['commercialCategory'] =
          category == 'All Commercial' ? null : category;
    });
  }

  void _selectRoomCategory(String category) {
    setState(() {
      _selectedRoomCategory = category;
      _filters['roomCategory'] = category == 'All Rooms' ? null : category;
    });
  }

  void _selectMonthlyRentCategory(String category) {
    setState(() {
      _selectedMonthlyRentCategory = category;
      _filters['monthlyRentCategory'] =
          category == 'All Monthly Rent' ? null : category;
    });
  }

  void _selectDailyRentCategory(String category) {
    setState(() {
      _selectedDailyRentCategory = category;
      _filters['dailyRentCategory'] =
          category == 'All Daily Rent' ? null : category;
    });
  }

  void _toggleBedroom(String bedroom) {
    setState(() {
      if (_selectedBedrooms.contains(bedroom)) {
        _selectedBedrooms.remove(bedroom);
      } else {
        _selectedBedrooms.add(bedroom);
      }
      _filters['bedrooms'] =
          _selectedBedrooms.isEmpty ? null : _selectedBedrooms.toList();
    });
  }

  void _toggleBathroom(String bathroom) {
    setState(() {
      if (_selectedBathrooms.contains(bathroom)) {
        _selectedBathrooms.remove(bathroom);
      } else {
        _selectedBathrooms.add(bathroom);
      }
      _filters['bathrooms'] =
          _selectedBathrooms.isEmpty ? null : _selectedBathrooms.toList();
    });
  }

  void _updatePriceRange(RangeValues values) {
    setState(() {
      _priceRange = values;
      _filters['priceRange'] = {
        'min': values.start.round(),
        'max': values.end.round(),
      };
      // Update text controllers without losing focus if possible
      if (values.start.round().toString() != _priceMinController.text) {
        _priceMinController.text = values.start.round().toString();
      }
      if (values.end.round().toString() != _priceMaxController.text) {
        _priceMaxController.text = values.end.round().toString();
      }
    });
  }

  void _updateAreaRange(RangeValues values) {
    setState(() {
      _areaRange = values;
      _filters['areaRange'] = {
        'min': values.start.round(),
        'max': values.end.round(),
      };
      // Update text controllers
      if (values.start.round().toString() != _areaMinController.text) {
        _areaMinController.text = values.start.round().toString();
      }
      if (values.end.round().toString() != _areaMaxController.text) {
        _areaMaxController.text = values.end.round().toString();
      }
    });
  }

  void _selectFurnishing(String? furnishing) {
    setState(() {
      _selectedFurnishing = furnishing; // Will be null if 'All' is selected
      _filters['furnishing'] = _selectedFurnishing;
    });
  }

  void _addExcludedLocation(String location) {
    if (location.trim().isNotEmpty &&
        !_excludedLocations.contains(location.trim())) {
      setState(() {
        _excludedLocations.add(location.trim());
        _filters['excludeLocations'] = _excludedLocations.toList();
      });
      _excludeLocationController.clear(); // Clear the input field
    }
  }

  void _removeExcludedLocation(String location) {
    setState(() {
      _excludedLocations.remove(location);
      _filters['excludeLocations'] =
          _excludedLocations.isEmpty ? null : _excludedLocations.toList();
    });
  }

  void _toggleAmenity(String amenity) {
    setState(() {
      if (_selectedAmenities.contains(amenity)) {
        _selectedAmenities.remove(amenity);
      } else {
        _selectedAmenities.add(amenity);
      }
      _filters['amenities'] =
          _selectedAmenities.isEmpty ? null : _selectedAmenities.toList();
    });
  }

  void _updateKeyword(String keyword) {
    setState(() {
      // Ensure state updates if needed elsewhere
      _filters['keyword'] = keyword.trim().isEmpty ? null : keyword.trim();
    });
  }

  void _toggleListedBy(String by) {
    setState(() {
      if (_listedBy.contains(by)) {
        _listedBy.remove(by);
      } else {
        _listedBy.add(by);
      }
      _filters['listedBy'] = _listedBy.isEmpty ? null : _listedBy.toList();
    });
  }

  void _updateRealEstateAgencies(String agencies) {
    setState(() {
      // Ensure state updates if needed elsewhere
      _filters['realEstateAgencies'] =
          agencies.trim().isEmpty ? null : agencies.trim();
    });
  }

  void _selectRentPaid(String? paid) {
    setState(() {
      _rentPaid = paid;
      _filters['rentPaid'] = paid;
    });
  }

  void _toggleAdsInEnglish() {
    setState(() {
      _adsInEnglish = !_adsInEnglish;
      _filters['adsInEnglish'] = _adsInEnglish;
    });
  }

  void _toggleAdsWithVideo() {
    setState(() {
      _adsWithVideo = !_adsWithVideo;
      _filters['adsWithVideo'] = _adsWithVideo;
    });
  }

  void _toggleAdsWith360Tour() {
    setState(() {
      _adsWith360Tour = !_adsWith360Tour;
      _filters['adsWith360Tour'] = _adsWith360Tour;
    });
  }

  // --- Build Method and Helpers (copied from _FilterBuyState, minor adjustments) ---
  @override
  Widget build(BuildContext context) {
    // Determine current categories based on selected property type
    final List<String> currentCategories =
        _propertyCategories[_selectedPropertyType] ?? [];
    final List<String> commercialCategories =
        _propertyCategories['Commercial'] ?? [];
    final List<String> roomCategories = _propertyCategories['Rooms'] ?? [];
    final List<String> monthlyRentCategories =
        _propertyCategories['Monthly Rent'] ?? [];
    final List<String> dailyRentCategories =
        _propertyCategories['Daily Rent'] ?? [];

    return Scaffold(
      // Removed AppBar from here, it's in FilterPage now
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Added spacing if AppBar removed
            const Text(
              "Location",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_pin),
                prefixIconColor: Colors.grey,
                labelText: 'e.g. Paris, Downtown', // Updated hint text
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Add controller and onChanged/onSubmitted logic for location if needed
            ),
            const SizedBox(height: 2),
            const Text(
              "Select cities, neighborhoods, or buildings.", // Simplified instruction
              style: TextStyle(
                  fontSize: 12, color: Colors.grey, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 25),

            // Property Type Section
            const Text(
              "Property Type",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPropertyTypeOption(
                    "Residential",
                    Icons.home_outlined,
                  ), // Updated icons
                  _buildPropertyTypeOption(
                    "Commercial",
                    Icons.business_center_outlined,
                  ),
                  _buildPropertyTypeOption(
                    "Rooms",
                    Icons.meeting_room_outlined,
                  ),
                  _buildPropertyTypeOption(
                    "Monthly Rent",
                    Icons.calendar_today_outlined,
                  ),
                  _buildPropertyTypeOption(
                    "Daily Rent",
                    Icons.access_time_outlined,
                  ),
                ]
                    .map(
                      (widget) => Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: widget,
                      ),
                    )
                    .toList(), // Added padding
              ),
            ),
            const SizedBox(height: 25),

            // --- Conditional Category Sections ---
            if (_selectedPropertyType == 'Residential' &&
                currentCategories.isNotEmpty) ...[
              _buildCategorySection(
                "Residential Categories",
                currentCategories,
                _selectedCategory,
                _selectCategory,
              ),
              const SizedBox(height: 25),
            ],
            if (_selectedPropertyType == 'Commercial' &&
                commercialCategories.isNotEmpty) ...[
              _buildCategorySection(
                "Commercial Categories",
                commercialCategories,
                _selectedCommercialCategory,
                _selectCommercialCategory,
              ),
              const SizedBox(height: 25),
            ],
            if (_selectedPropertyType == 'Rooms' &&
                roomCategories.isNotEmpty) ...[
              _buildCategorySection(
                "Room Categories",
                roomCategories,
                _selectedRoomCategory,
                _selectRoomCategory,
              ),
              const SizedBox(height: 25),
            ],
            if (_selectedPropertyType == 'Monthly Rent' &&
                monthlyRentCategories.isNotEmpty) ...[
              _buildCategorySection(
                "Monthly Rent Categories",
                monthlyRentCategories,
                _selectedMonthlyRentCategory,
                _selectMonthlyRentCategory,
              ),
              const SizedBox(height: 25),
            ],
            if (_selectedPropertyType == 'Daily Rent' &&
                dailyRentCategories.isNotEmpty) ...[
              _buildCategorySection(
                "Daily Rent Categories",
                dailyRentCategories,
                _selectedDailyRentCategory,
                _selectDailyRentCategory,
              ),
              const SizedBox(height: 25),
            ],

            // Price Range Section
            const Text(
              "Price Range",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            // Using RangeSlider for better UX
            RangeSlider(
              values: _priceRange,
              min: 0,
              max: 1000000, // Adjust max as needed
              divisions: 100, // Adjust divisions for granularity
              labels: RangeLabels(
                '${_priceRange.start.round()} \$', // Added currency/unit
                '${_priceRange.end.round()} \$',
              ),
              onChanged: (values) {
                _updatePriceRange(values);
              },
              onChangeEnd: (values) {
                // Update text fields only when user finishes sliding
                _priceMinController.text = values.start.round().toString();
                _priceMaxController.text = values.end.round().toString();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: _buildRangeTextField(
                    _priceMinController,
                    'Min',
                    (v) => _updateRangeFromText(v, isMin: true, isPrice: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildRangeTextField(
                    _priceMaxController,
                    'Max',
                    (v) => _updateRangeFromText(v, isMin: false, isPrice: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Bedrooms Section
            const Text(
              "Bedrooms",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _bedroomOptions
                  .map(
                    (bedroom) => _buildSelectableChip(
                      bedroom,
                      _selectedBedrooms.contains(bedroom),
                      () => _toggleBedroom(bedroom),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),

            // Bathrooms Section
            const Text(
              "Bathrooms",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _bathroomOptions
                  .map(
                    (bathroom) => _buildSelectableChip(
                      bathroom,
                      _selectedBathrooms.contains(bathroom),
                      () => _toggleBathroom(bathroom),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),

            // Area/Size Section
            const Text(
              "Area/Size (sqft)",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            RangeSlider(
              values: _areaRange,
              min: 0,
              max: 5000, // Adjust max as needed
              divisions: 100, // Adjust divisions
              labels: RangeLabels(
                '${_areaRange.start.round()} sqft',
                '${_areaRange.end.round()} sqft',
              ),
              onChanged: (values) {
                _updateAreaRange(values);
              },
              onChangeEnd: (values) {
                _areaMinController.text = values.start.round().toString();
                _areaMaxController.text = values.end.round().toString();
              },
            ),
            Row(
              children: [
                Expanded(
                  child: _buildRangeTextField(
                    _areaMinController,
                    'Min',
                    (v) => _updateRangeFromText(v, isMin: true, isPrice: false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildRangeTextField(
                    _areaMaxController,
                    'Max',
                    (v) =>
                        _updateRangeFromText(v, isMin: false, isPrice: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // Furnishing Type Section
            const Text(
              "Furnishing Type",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _furnishingOptions.map((furnishing) {
                // 'All' is selected if _selectedFurnishing is null
                final isSelected =
                    (_selectedFurnishing == null && furnishing == 'All') ||
                        _selectedFurnishing == furnishing;
                return _buildSelectableChip(
                  furnishing,
                  isSelected,
                  // Pass null to the handler if 'All' is tapped, otherwise the furnishing type
                  () => _selectFurnishing(
                    furnishing == 'All' ? null : furnishing,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),

            // Exclude Locations Section
            const Text(
              "Exclude Locations",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _excludeLocationController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_off_outlined),
                prefixIconColor: Colors.grey,
                labelText: 'e.g. Old Town, Specific Building', // Updated hint
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _addExcludedLocation, // Use the handler
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 6.0,
              runSpacing: 0,
              children: _excludedLocations
                  .map(
                    (location) => Chip(
                      label: Text(location),
                      onDeleted: () => _removeExcludedLocation(
                        location,
                      ), // Use handler
                      deleteIconColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),

            // Amenities Section
            const Text(
              "Amenities",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _amenitiesOptions
                  .map(
                    (amenity) => _buildSelectableChip(
                      amenity,
                      _selectedAmenities.contains(amenity),
                      () => _toggleAmenity(amenity),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),

            // Keyword Section
            const Text(
              "Keyword",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(
                // Improved decoration
                hintText: 'e.g. pool, security, ref id',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _updateKeyword, // Use handler
            ),
            const SizedBox(height: 25),

            // Listed By Section
            const Text(
              "Listed By",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _listedByOptions
                  .map(
                    (by) => _buildSelectableChip(
                      by,
                      _listedBy.contains(by),
                      () => _toggleListedBy(by),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),

            // Real Estate Agencies Section
            const Text(
              "Real Estate Agencies",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: _realEstateAgenciesController,
              decoration: InputDecoration(
                // Improved decoration
                hintText: 'Enter agency names (comma separated)',
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _updateRealEstateAgencies, // Use handler
            ),
            const SizedBox(height: 25),

            // Rent is Paid Section (Conditional display might be better based on Property Type)
            if (_selectedPropertyType != 'Commercial' &&
                _selectedPropertyType !=
                    'Residential') // Example: Only show for Rent types
              ...[
              const Text(
                "Rent is Paid",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _rentPaidOptions
                    .map(
                      (paid) => _buildSelectableChip(
                        paid,
                        _rentPaid == paid,
                        () => _selectRentPaid(paid),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 25),
            ],

            // More Filters Section
            const Text(
              "More Filters",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 15), // Adjusted spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconToggleOption(
                  "Ads in English",
                  Icons.translate,
                  _adsInEnglish,
                  _toggleAdsInEnglish,
                ),
                _buildIconToggleOption(
                  "Ads with Video",
                  Icons.videocam_outlined,
                  _adsWithVideo,
                  _toggleAdsWithVideo,
                ), // Updated icon
                _buildIconToggleOption(
                  "Ads with 360 Tour",
                  Icons.threed_rotation_outlined,
                  _adsWith360Tour,
                  _toggleAdsWith360Tour,
                ), // Updated icon
              ],
            ),
            const SizedBox(height: 30),

            // --- Action Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: const Text(
                    "Reset Filters",
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Example color
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "Apply Filters",
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  // --- Helper for Range TextFields ---
  Widget _buildRangeTextField(
    TextEditingController controller,
    String label,
    Function(String) onChanged,
  ) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
      ), // No decimals
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      onChanged: onChanged,
    );
  }

  // --- Update RangeSlider from TextField Input ---
  void _updateRangeFromText(
    String value, {
    required bool isMin,
    required bool isPrice,
  }) {
    final double? newValue = double.tryParse(value);
    if (newValue == null) return; // Ignore invalid input

    setState(() {
      if (isPrice) {
        final currentStart = _priceRange.start;
        final currentEnd = _priceRange.end;
        if (isMin) {
          if (newValue <= currentEnd) {
            // Ensure min <= max
            _priceRange = RangeValues(newValue, currentEnd);
            _filters['priceRange'] = {
              'min': newValue.round(),
              'max': currentEnd.round(),
            };
          } else {
            // Optionally reset or show error
            _priceMinController.text = currentStart.round().toString();
          }
        } else {
          // is Max
          if (newValue >= currentStart) {
            // Ensure max >= min
            _priceRange = RangeValues(currentStart, newValue);
            _filters['priceRange'] = {
              'min': currentStart.round(),
              'max': newValue.round(),
            };
          } else {
            // Optionally reset or show error
            _priceMaxController.text = currentEnd.round().toString();
          }
        }
      } else {
        // is Area
        final currentStart = _areaRange.start;
        final currentEnd = _areaRange.end;
        if (isMin) {
          if (newValue <= currentEnd) {
            _areaRange = RangeValues(newValue, currentEnd);
            _filters['areaRange'] = {
              'min': newValue.round(),
              'max': currentEnd.round(),
            };
          } else {
            _areaMinController.text = currentStart.round().toString();
          }
        } else {
          // is Max
          if (newValue >= currentStart) {
            _areaRange = RangeValues(currentStart, newValue);
            _filters['areaRange'] = {
              'min': currentStart.round(),
              'max': newValue.round(),
            };
          } else {
            _areaMaxController.text = currentEnd.round().toString();
          }
        }
      }
    });
  }

  // --- Helper to build category sections ---
  Widget _buildCategorySection(
    String title,
    List<String> categories,
    String? selectedValue,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'SourceSans3')),
        const SizedBox(height: 5),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories
                .map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    // Using the FilterChip helper for consistency
                    child: _buildSelectableChip(
                      category,
                      selectedValue == category,
                      () => onSelect(category),
                      isCategory:
                          true, // Indicate it's for single selection style
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  // --- Original Build Helpers adjusted ---
  Widget _buildPropertyTypeOption(String label, IconData icon) {
    final isSelected = _selectedPropertyType == label;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey[700],
        size: 18,
      ),
      selected: isSelected,
      onSelected: (_) => _selectPropertyType(label),
      selectedColor: Colors.red, // Theme primary color
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      showCheckmark: false,
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildSelectableChip(
    String label,
    bool isSelected,
    VoidCallback onTap, {
    bool isCategory = false,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Colors.red[100], // Lighter selection color
      checkmarkColor: Colors.redAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.red : Colors.grey[400]!,
        ),
      ),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.red[700] : Colors.black87,
        fontSize: 13,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      // Use checkmark only for multi-select, not single-select categories/furnishing etc.
      showCheckmark: !isCategory &&
          label != 'All' &&
          label != 'Furnished' &&
          label != 'Unfurnished' &&
          !_rentPaidOptions.contains(label),
    );
  }

  Widget _buildIconToggleOption(
    String label,
    IconData icon,
    bool value,
    VoidCallback onChanged,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          // Using OutlinedButton for better visual feedback
          onPressed: onChanged,
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            side: BorderSide(
              color: value ? Colors.red : Colors.grey[400]!,
            ),
            backgroundColor: value ? Colors.red[50] : Colors.white,
          ),
          child: Icon(icon, color: value ? Colors.red : Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontFamily: 'SourceSans3'),
        ),
      ],
    );
  }
} // End of _FilterFormContentState

// 3. Updated FilterBuy Widget
class FilterBuy extends StatelessWidget {
  const FilterBuy({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply return the shared content widget
    return const _FilterFormContent();
  }
}

// 4. Updated FilterRent Widget
class FilterRent extends StatelessWidget {
  const FilterRent({super.key});

  @override
  Widget build(BuildContext context) {
    // Simply return the shared content widget
    return const _FilterFormContent();
  }
}

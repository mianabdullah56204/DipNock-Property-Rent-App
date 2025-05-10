import 'package:app/pages/favourites.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/listing_page.dart';
import 'package:app/providers/favourites_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FavouritesProvider(),
      child: MaterialApp(
        title: 'Dipnock',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              scrolledUnderElevation: 0),
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          // Define other theme properties if needed
          textTheme: const TextTheme(
            // Example text theme
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceSans3',
            ),
            titleMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'SourceSans3',
            ),
            bodyLarge: TextStyle(fontSize: 16.0, fontFamily: 'SourceSans3'),
            bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'SourceSans3'),
            bodySmall: TextStyle(fontSize: 12.0, fontFamily: 'SourceSans3'),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[150],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            // Example button theme
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
          ),
        ),
        home: HomePage(), // Your initial screen
        // Define routes for navigation
        routes: {
          '/listings': (context) => const ListingPage(),
          '/favourites': (context) => const FavouritesPage(),
          // Add other routes like '/login', '/details', etc.
        },
        debugShowCheckedModeBanner: false, // Remove debug banner
      ),
    );
  }
}

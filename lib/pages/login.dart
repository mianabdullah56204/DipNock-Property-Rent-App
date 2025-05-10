import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme data

    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: SafeArea(
        // Ensure content is below status bar etc.
        child: SingleChildScrollView(
          // Allow scrolling on smaller screens
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 20.0,
          ), // Consistent padding
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align content to the left
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Space between text and image
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login or Sign up", // Clearer title
                        style: theme.textTheme.headlineSmall?.copyWith(
                          // Use theme style
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Welcome! Enter your details below.", // Updated tagline
                        style: theme.textTheme.bodyMedium?.copyWith(
                          // Use theme style
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  //  Spacer(), // Use Spacer if needed, but spaceBetween might suffice
                  Image.asset(
                    "assets/find_home.png", // Ensure this asset exists
                    width: 60,
                    height: 60,
                    // Optional: Add error handling for image loading
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.home_work_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ), // Space before phone input instruction
              // --- Phone Input Section ---
              Text(
                "Enter Phone to continue",
                style: theme.textTheme.titleMedium?.copyWith(
                  // Use theme style
                  fontWeight: FontWeight.w600, // Slightly bolder
                ),
              ),
              const SizedBox(height: 20),
              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  // Modern Input Border Style
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12.0,
                    ), // Rounded corners
                    borderSide: BorderSide(
                      color: Colors.grey[400]!,
                    ), // Default border color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey[400]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                      width: 1.5,
                    ), // Highlight focus
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ), // Adjust padding
                ),
                style:
                    theme.textTheme.bodyLarge, // Use theme text style for input
                initialCountryCode: 'PK', // Your default country code
                onChanged: (phone) {
                  // Handle phone number changes - phone.completeNumber contains country code + number
                  print(phone.completeNumber);
                },
                // Restrict input to digits only
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // Improve keyboard type for numbers
                keyboardType: TextInputType.phone,
                // Change dropdown icon
                dropdownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30), // Space before button
              // --- Continue Button ---
              SizedBox(
                // Use SizedBox to constrain the button width
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: () {
                    // Implement login/continue logic
                    print("Continue button pressed");
                    // Example: Navigator.push(...) or validate OTP etc.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme
                        .primaryColor, // Use theme primary color (e.g., redAccent)
                    foregroundColor: Colors.white, // Text color on button
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ), // Taller button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ), // Match input field radius
                    ),
                    elevation: 2, // Subtle shadow
                  ),
                  child: Text(
                    "Continue",
                    style: theme.textTheme.titleMedium?.copyWith(
                      // Use theme style
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Space before footer text
              // --- Footer Text (Terms & Conditions, Contact) ---
              Center(
                child: Wrap(
                  // Use Wrap for better text flow on small screens
                  alignment:
                      WrapAlignment.center, // Center align lines within Wrap
                  runSpacing: 8.0, // Space between lines if it wraps
                  children: [
                    Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ), // Base style for footer
                        children: <TextSpan>[
                          const TextSpan(
                            text: "By continuing, you agree to our ",
                          ),
                          TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(
                              fontWeight: FontWeight.w600, // Make link bolder
                              color: theme
                                  .primaryColor, // Use primary color for link
                              // decoration: TextDecoration.underline, // Optional underline
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Terms & Conditions tapped');
                                // _launchUrl('YOUR_TERMS_URL_HERE'); // Optional: Launch URL
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text.rich(
                      TextSpan(
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: "For any issue/query please email ",
                          ),
                          TextSpan(
                            text: "support@example.com", // Your support email
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Email tapped');
                                // _launchUrl('mailto:support@example.com'); // Optional: Launch Mail client
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}

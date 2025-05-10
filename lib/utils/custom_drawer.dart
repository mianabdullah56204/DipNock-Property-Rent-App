import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final Function onLoginTap; // Callback for login action
  final Function? onSignUpTap; // Optional: Callback for sign-up action

  const CustomDrawer({
    super.key,
    required this.onLoginTap,
    this.onSignUpTap, // Make sign-up optional
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get theme data
    final safeAreaPadding = MediaQuery.of(context).padding; // Get safe area insets

    return Container(
      width: MediaQuery.of(context).size.width, // Keeping full width as per original
      color: Colors.white, // Main background of the drawer
      child: Column( // Use Column as the base layout
        children: [
          // --- Colored Header for Auth ---
          Container(
            padding: EdgeInsets.only(
              top: safeAreaPadding.top + 16.0, // Add safe area padding + extra space
              bottom: 24.0, // More bottom padding
              left: 20.0,
              right: 20.0,
            ),
            // Use a gradient or a solid color from the theme
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Example: Avatar or Logo
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.person_outline, size: 35, color: Colors.black54),
                  // Replace with actual user avatar if logged in
                ),
                const SizedBox(height: 15),
                // Welcome Text or User Name
                Text(
                  "Welcome Guest!", // Replace with user name if logged in
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  "Sign in or create an account",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 20),
                // Login/Sign Up Buttons
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => onLoginTap(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White button
                        foregroundColor: theme.primaryColor, // Text color matching header
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: const Text("Sign In"),
                    ),
                    const SizedBox(width: 12),
                    // Optional Sign Up Button
                    if (onSignUpTap != null)
                      TextButton(
                        onPressed: () => onSignUpTap!(),
                         style: TextButton.styleFrom(
                           foregroundColor: Colors.white, // White text
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.white.withOpacity(0.7)) // Subtle border
                            ),
                           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text("Sign Up"),
                      ),
                  ],
                )
              ],
            ),
          ),

          // --- Scrollable List of Items ---
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove default ListView padding
              children: [
                const SizedBox(height: 10), // Space before the list starts
                _buildExpandableTile(context, "My Services", Icons.settings_outlined),
                _buildDivider(),
                _buildExpandableTile(context, "Residential Plans", Icons.home_work_outlined),
                 _buildDivider(),
                _buildExpandableTile(context, "Commercial Plans", Icons.business_center_outlined),
                 _buildDivider(),
                _buildExpandableTile(context, "Home Services", Icons.construction_outlined),
                _buildDivider(),
                 // Non-expandable example
                _buildListTile(context, "Pay Bills", Icons.payment_outlined, () {
                  print("Pay Bills tapped");
                  // Navigate or perform action
                }),
                 _buildDivider(),
                _buildListTile(context, "Utilities", Icons.electrical_services_outlined, () {
                   print("Utilities tapped");
                }),
                 _buildDivider(),
                _buildListTile(context, "Help & Support", Icons.help_outline, () {
                   print("Help tapped");
                }),
                const SizedBox(height: 20), // Space before footer
              ],
            ),
          ),

          // --- Footer ---
          Padding(
            padding: EdgeInsets.only(
              bottom: safeAreaPadding.bottom + 16.0, // Respect safe area at bottom
              top: 16.0
            ),
            child: Center(
              child: Text(
                "Version 1.0.0", // Your app version
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Helper for building modern ExpansionTiles
  Widget _buildExpandableTile(BuildContext context, String title, IconData icon) {
     final theme = Theme.of(context);
    return ExpansionTile(
      leading: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7)), // Use theme icon color
      tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0), // Adjust padding
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500), // Style from theme
      ),
      // Use simpler icons for expand/collapse
      trailing: Icon(
        Icons.keyboard_arrow_down,
        color: theme.iconTheme.color?.withOpacity(0.5), // Subtle trailing icon
      ),
      // Remove the default underline border
      collapsedShape: const Border(),
      shape: const Border(),
      // Style for the children when expanded
      childrenPadding: const EdgeInsets.only(left: 30.0), // Indent children slightly more
      children: [
        // Example children - replace with your actual sub-items
        _buildListTile(context, "$title Page 1", Icons.chevron_right, () {}),
        _buildListTile(context, "$title Page 2", Icons.chevron_right, () {}),
      ],
      onExpansionChanged: (isExpanded) {
        // Optional: Handle state change if needed
      },
    );
  }

  // Helper for building standard ListTiles consistently
   Widget _buildListTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
     final theme = Theme.of(context);
     return ListTile(
        leading: Icon(icon, color: theme.iconTheme.color?.withOpacity(0.7), size: 22),
        title: Text(
          title,
           style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0), // Consistent padding
        dense: true, // Make items slightly more compact
        onTap: onTap,
     );
   }

  // Helper for a subtle divider
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0), // Match list tile padding
      child: Divider(
        height: 1, // Minimal height
        thickness: 1, // Minimal thickness
        color: Colors.grey[200], // Very light color
      ),
    );
  }
}
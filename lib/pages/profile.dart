import 'package:app/pages/favourites.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfilePage({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Account",
            style: TextStyle(fontFamily: 'SourceSans3'),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top Profile Card
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          backgroundImage: userData['photoUrl'] != null
                              ? NetworkImage(userData['photoUrl'])
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData['name'] ?? 'User Name',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SourceSans3'),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '@${userData['username'] ?? 'username'}',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'SourceSans3'),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      userData['location'] ?? 'Location',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'SourceSans3'),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Edit icon in the top right corner of the card
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(userData: userData),
                          ),
                        );
                        print('Edit button pressed');
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (userData['joinedDate'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Joined on ${userData['joinedDate']}',
                  style: TextStyle(fontFamily: 'SourceSans3'),
                ),
              ),
            const SizedBox(height: 16),
            // Action button: Place an Ad
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaceAdPage()),
                );
                print('Place an ad button pressed');
              },
              child: const Text('Place an Ad',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'SourceSans3')),
            ),
            const SizedBox(height: 24),
            // Account Section with Dividers
            _buildSectionHeader('Account'),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(
                    userData['phoneNumber'] ?? 'Phone Number',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(
                    userData['email'] ?? 'Email ID',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Preferences Section with Dividers
            _buildSectionHeader('Preferences'),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: const Text(
                    'My Favourites',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FavouritesPage(),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: const Text(
                    'Privacy',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    print('Privacy tapped');
                    // TODO: Navigate to Privacy settings
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications_none_outlined),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    print('Notifications tapped');
                    // TODO: Navigate to Notification settings
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Support Section with Dividers
            _buildSectionHeader('Support'),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text(
                    'Help & Support',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportPage(),
                      ),
                    );
                    print('Help & Support tapped');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text(
                    'Terms and conditions',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    print('Terms and conditions tapped');
                    // TODO: Navigate to Terms and Conditions
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontFamily: 'SourceSans3'),
                  ),
                  onTap: () {
                    print('Logout tapped');
                    // TODO: Implement logout functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceSans3'),
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.userData['name'] ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.userData['username'] ?? '',
    );
    _locationController = TextEditingController(
      text: widget.userData['location'] ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // In a real app, update the user profile here.
    print('Name: ${_nameController.text}');
    print('Username: ${_usernameController.text}');
    print('Location: ${_locationController.text}');

    // After saving, pop the page.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Edit Profile',
        style: TextStyle(fontFamily: 'SourceSans3'),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 24),
            // Confirm Button at the bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Confirm',
                    style: TextStyle(fontSize: 16, fontFamily: 'SourceSans3')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Help & Support',
        style: TextStyle(fontFamily: 'SourceSans3'),
      )),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.call_outlined),
            title: const Text(
              'Call',
              style: TextStyle(fontFamily: 'SourceSans3'),
            ),
            onTap: () {
              print('Call tapped');
              // TODO: Implement call functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text(
              'Chat',
              style: TextStyle(fontFamily: 'SourceSans3'),
            ),
            onTap: () {
              print('Chat tapped');
              // TODO: Implement chat functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.school_outlined),
            title: const Text(
              'Tutorials',
              style: TextStyle(fontFamily: 'SourceSans3'),
            ),
            onTap: () {
              print('Tutorials tapped');
              // TODO: Implement tutorials navigation
            },
          ),
        ],
      ),
    );
  }
}

class PlaceAdPage extends StatelessWidget {
  const PlaceAdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Place an Ad',
        style: TextStyle(fontFamily: 'SourceSans3'),
      )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fill in the details to place your advertisement:',
              style: TextStyle(fontSize: 16, fontFamily: 'SourceSans3'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                print('Submit Ad button pressed');
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                  'Ad submitted!',
                  style: TextStyle(fontFamily: 'SourceSans3'),
                )));
                Navigator.pop(context);
              },
              child: const Text(
                'Submit Ad',
                style: TextStyle(fontFamily: 'SourceSans3'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

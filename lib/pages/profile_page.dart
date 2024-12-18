import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

// Get the API URL from .env file
String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Loading..."; // Default value
  bool isLoading = true; // To show loading state

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Function to fetch user data from the API
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$apiUrl/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('API Response: ${response.body}');
      }
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body);
          if (kDebugMode) {
            print('Parsed Data: $data');
          }

          if (data != null && data['name'] != null) {
            setState(() {
              userName = data['name']; // Get the user name from the response
              isLoading = false; // Stop loading
            });
          } else {
            setState(() {
              userName = "Data not found"; // Error handling if 'name' not found
              isLoading = false;
            });
          }
        } catch (e) {
          setState(() {
            userName = "Failed to load data"; // Error handling if JSON parsing fails
            isLoading = false;
          });
        }
      } else {
        setState(() {
          userName = "Failed to access server"; // Error handling if the status code is not 200
          isLoading = false;
        });
      }
    } else {
      setState(() {
        userName = "Token not found"; // If token is not found in SharedPreferences
        isLoading = false;
      });
    }
  }

  // Function to logout
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Remove the auth token

    // Replace the current route with the login screen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Ganti dengan halaman login Anda
          (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user.jpg'), // Change to the path of the user's profile picture
          ),

          const SizedBox(height: 16),

          // User Name
          isLoading
              ? const CircularProgressIndicator() // Loading indicator
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.edit,
                color: Colors.red,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Profile Menu
          Expanded(
            child: ListView(
              children: [
                ProfileMenuItem(
                  icon: Icons.settings,
                  title: 'Pengaturan',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.lock,
                  title: 'Privasi',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.security,
                  title: 'Keamanan',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.notifications,
                  title: 'Notifikasi',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.help,
                  title: 'Pusat Bantuan',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.phone,
                  title: 'Hubungi HealthyPet',
                  onTap: () {},
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Keluar',
                  onTap: () {
                    _logout(context); // Call the logout function
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? Colors.red : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: isLogout ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
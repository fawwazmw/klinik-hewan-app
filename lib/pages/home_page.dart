import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Get the API URL from .env file
String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Loading..."; // Default value
  bool isLoadingUser = true; // Untuk loading user data
  bool isLoadingPromo = true; // Untuk loading promo
  bool isLoadingInformasi = true; // Untuk loading informasi
  List<dynamic> promoItems = []; // Data promo yang diambil dari API
  List<dynamic> informasiItems = []; // Data informasi terkini

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPromoItems();
    _fetchInformasiItems();
  }

  // Fungsi untuk mengambil data pengguna dari API
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
        print('User API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body);
          if (kDebugMode) {
            print('User Data Parsed: $data');
          }

          setState(() {
            userName = data['name'] ?? "Data tidak ditemukan";
            isLoadingUser = false;
          });
        } catch (e) {
          setState(() {
            userName = "Gagal memuat data";
            isLoadingUser = false;
          });
        }
      } else {
        setState(() {
          userName = "Gagal mengakses server";
          isLoadingUser = false;
        });
      }
    } else {
      setState(() {
        userName = "Token tidak ditemukan";
        isLoadingUser = false;
      });
    }
  }

  // Fungsi untuk mengambil data promo dari API
  Future<void> _fetchPromoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$apiUrl/obat'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('Promo API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body)['data'] as List;
          setState(() {
            promoItems = data.take(3).toList(); // Ambil maksimal 3 promo
            isLoadingPromo = false;
          });
        } catch (e) {
          setState(() {
            promoItems = [];
            isLoadingPromo = false;
          });
        }
      } else {
        setState(() {
          promoItems = [];
          isLoadingPromo = false;
        });
      }
    } else {
      setState(() {
        promoItems = [];
        isLoadingPromo = false;
      });
    }
  }

  // Fungsi untuk mengambil data informasi terkini dari API
  Future<void> _fetchInformasiItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$apiUrl/informasi'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('Informasi API Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body)['data'] as List;
          setState(() {
            informasiItems = data.take(2).toList(); // Ambil maksimal 2 informasi
            isLoadingInformasi = false;
          });
        } catch (e) {
          setState(() {
            informasiItems = [];
            isLoadingInformasi = false;
          });
        }
      } else {
        setState(() {
          informasiItems = [];
          isLoadingInformasi = false;
        });
      }
    } else {
      setState(() {
        informasiItems = [];
        isLoadingInformasi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar and Avatar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Masukkan yang anda cari...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.jpg'),
                    radius: 20,
                  ),
                ],
              ),
            ),

            // Welcome Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isLoadingUser
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'Hi, Health! $userName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Pantau kesehatan hewan peliharaanmu dengan mudah!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryItem(
                    context,
                    Icons.pets,
                    'GrowUp',
                    '/tumbuhkembang',
                  ),
                  _buildCategoryItem(
                    context,
                    Icons.local_dining,
                    'NutriPets',
                    '/nutrition',
                  ),
                  _buildCategoryItem(
                    context,
                    Icons.store,
                    'PetShop',
                    '/petshop',
                  ),
                  _buildCategoryItem(
                    context,
                    Icons.vaccines,
                    'Vaksinasi',
                    '/vaccination',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Hot Promo Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hot Promo 🔥',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoadingPromo
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: promoItems.map((item) {
                      return _buildPromoItem(
                        item['nama_obat'], // Nama Obat
                        'Rp. ${item['harga']}', // Harga Obat
                        'assets/images/antibiotik.jpg', // Placeholder Image
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informasi Terkini
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Terkini',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  isLoadingInformasi
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Column(
                    children: informasiItems.map((item) {
                      return _buildInfoCard(
                        item['title'], // Title
                        item['owner'], // Owner (author)
                        'assets/images/berita1.jpg', // Placeholder image
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFB71C1C),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/consultation');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Consult',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
      BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(icon, color: const Color(0xFFB71C1C)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoItem(String title, String price, String imagePath) {
    // Remove the "Rp. " prefix and any quotes
    String cleanPrice = price.replaceAll('"', '').replaceAll('Rp. ', '');

    // Convert the string to double
    double priceValue = 0.0;
    try {
      // Split by dot and take first part (removing decimal places)
      String numberOnly = cleanPrice.split('.')[0];
      priceValue = double.parse(numberOnly);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing price: $e');
      }
      if (kDebugMode) {
        print('Original price string: $price');
      }
      if (kDebugMode) {
        print('Cleaned price string: $cleanPrice');
      }
    }

    // Format the price to Indonesian Rupiah format
    final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp ',
        decimalDigits: 0
    );
    String formattedPrice = formatter.format(priceValue);

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          formattedPrice,
          style: const TextStyle(color: Colors.yellow, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String author, String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'By $author',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

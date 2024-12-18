import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';  // Import the intl package
import 'package:shared_preferences/shared_preferences.dart';

String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  List<dynamic> doctors = [];
  bool isLoading = true;
  bool isTokenValid = true;

  @override
  void initState() {
    super.initState();
    _checkTokenAndFetchData();
  }

  Future<void> _checkTokenAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token != null) {
      _fetchDoctors(token);
    } else {
      setState(() {
        isTokenValid = false;
        isLoading = false;
      });
    }
  }

  Future<void> _fetchDoctors(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/dokter'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        try {
          var data = json.decode(response.body)['data'];
          setState(() {
            doctors = data;
            isLoading = false;
          });
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing JSON: $e');
          }
          setState(() {
            doctors = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          doctors = [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      setState(() {
        doctors = [];
        isLoading = false;
      });
    }
  }

  String formatPrice(String price) {
    // Remove the "Rp" prefix if exists and parse the number
    String cleanPrice = price.replaceAll('Rp', '').replaceAll(' ', '');
    double priceValue = double.tryParse(cleanPrice) ?? 0.0;

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return formatter.format(priceValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Konsultasi',
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isTokenValid)
              const Text(
                'Anda perlu login untuk mengakses halaman ini.',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari dokter, specialis atau gejala',
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  var doctor = doctors[index];
                  return DoctorCard(
                    name: doctor['nama'],
                    specialization: doctor['spesialis'],
                    experience: '${doctor['tahun']} tahun',
                    rating: '${doctor['kepuasan']}%',
                    price: formatPrice('Rp ${doctor['harga']}'),
                    image: 'assets/images/nicholas.jpg', // Static image
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String experience;
  final String rating;
  final String price;
  final String image;

  const DoctorCard({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.price,
    required this.image,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(image),
            ),
            const SizedBox(width: 16),
            Expanded(  // Wrap this part with Expanded to give it flexible space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,  // Prevent overflow for long names
                  ),
                  Text(
                    specialization,
                    overflow: TextOverflow.ellipsis,  // Prevent overflow for long specialization
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('$experience'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$rating Kepuasan',  // Rating below experience
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),  // Ensure space between the button and the text content
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class NutritionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang halaman putih
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C), // Latar belakang merah pada appBar
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kembali ke halaman home_page.dart
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text(
          'NutriPets',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Bagian dengan latar belakang merah
          Container(
            color: Color(0xFFB71C1C), // Latar belakang merah
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "selecting food",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Subtitle dengan teks putih di atas latar merah
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Rencanakan makanan terbaik untuk memastikan keseimbangan nutrisi setiap hari.",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Track Intake Section dengan teks merah
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Track Intake",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB71C1C), // Teks merah
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Calorie Image yang diperbesar
          Expanded(
            child: Center(
              child: _calorieImage(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Gambar Kalori yang lebih besar
  Widget _calorieImage() {
    return Center(
      child: SizedBox(
        width: 300, // Memperbesar ukuran gambar
        height: 300, // Memperbesar ukuran gambar
        child: Image.asset(
          'assets/images/kalori.jpg', // Ganti dengan nama gambar yang sesuai
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

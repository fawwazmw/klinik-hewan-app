import 'package:flutter/material.dart';

class VaccinationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB71C1C),
      appBar: AppBar(
        backgroundColor: Color(0xFFB71C1C),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Kembali ke halaman home_page.dart
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
        title: Text(
          'Vaksinasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFFB71C1C),
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Jangan lupa vaksinasi hewan kesayanganmu!",
              style: TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          // Calendar Image Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Calendar Image
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Image.asset(
                      'assets/images/kalender.jpg', // Path gambar kalender
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Vaccination Schedule
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        children: [
                          _vaccinationTile("09 April 2024",
                              "Vaksinasi Tetracat", Colors.orange),
                          _vaccinationTile(
                            "13 April 2024",
                            "Vaksinasi Rabies",
                            Color(0xFFB71C1C),
                          ),
                          _vaccinationTile(
                              "17 April 2024", "Vaksinasi F3", Colors.brown),
                          _vaccinationTile("30 April 2024", "Vaksinasi Tricat",
                              Colors.purple),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vaccinationTile(String date, String title, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border(left: BorderSide(color: color, width: 5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

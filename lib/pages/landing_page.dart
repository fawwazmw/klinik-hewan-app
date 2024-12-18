import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigasi otomatis setelah delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, '/login'); // Navigasi otomatis ke LoginPage
    });

    return Scaffold(
      backgroundColor: const Color(0xFFB71C1C), // Warna merah latar belakang
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3), // Spacer untuk jarak atas

          // Icon hati dengan paw dan heartbeat
          Center(
            child: Column(
              children: const [
                Icon(
                  Icons.favorite, // Ganti dengan ikon sesuai gambar
                  size: 150,
                  color: Colors.white,
                ),
                SizedBox(height: 16), // Jarak antara ikon dan teks
                Text(
                  'Kesehatan hewan anda\ndijamin di sini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(flex: 2), // Spacer untuk jarak bawah

          // Teks kebijakan di bagian bawah
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text.rich(
              TextSpan(
                text: 'Dengan masuk dan mendaftar, anda menyetujui ',
                style: TextStyle(color: Colors.white, fontSize: 12),
                children: [
                  TextSpan(
                    text: 'Ketentuan Layanan',
                    style: TextStyle(
                      color: Colors.yellow,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Colors.yellow,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const Spacer(flex: 1), // Spacer untuk jarak lebih bawah
        ],
      ),
    );
  }
}

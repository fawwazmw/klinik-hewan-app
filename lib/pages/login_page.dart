import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo atau judul di atas
          const Text(
            'HealthyPet',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20), // Jarak

          // Gambar utama (gunakan asset)
          Center(
            child: Image.asset(
              'assets/images/awal.jpg', // Path gambar
              height: 200,
            ),
          ),

          const SizedBox(height: 20), // Jarak

          // Tombol "Masuk"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/login_screen'); // Navigasi ke LoginPage
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Masuk',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white), // Warna teks diubah menjadi putih
                ),
              ),
            ),
          ),

          const SizedBox(height: 15), // Jarak antar tombol

          // Tombol "Daftar"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(
                    context, '/register'); // Navigasi ke RegisterPage
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Center(
                child: Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Jarak

          // Teks kebijakan di bawah
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text.rich(
              TextSpan(
                text: 'Dengan masuk dan mendaftar, anda menyetujui ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  TextSpan(
                    text: 'Ketentuan Layanan',
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' dan '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

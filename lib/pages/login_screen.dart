import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myhealthypet/pages/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Get the API URL from .env file
String apiUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/api';

// Fungsi untuk melakukan login
Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$apiUrl/login'),
    body: {
      'email': email,
      'password': password,
    },
  );

  if (response.statusCode == 200) {
    // Jika login berhasil, simpan token di local storage
    var data = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', data['token']);

    return {
      'success': true,
      'message': 'Login successful',
      'token': data['token'],
    };
  } else {
    return {
      'success': false,
      'message': 'Invalid credentials',
    };
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/home': (context) => const HomePage(), // Menambahkan route untuk halaman HomePage
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Menandakan status loading saat login

  // Fungsi untuk handle login
  void _handleLogin() async {
    setState(() {
      _isLoading = true; // Menampilkan indikator loading
    });

    // Panggil fungsi login
    var result = await login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false; // Menyembunyikan indikator loading
    });

    // Tanggapi hasil login
    if (result['success']) {
      // Jika login berhasil, tampilkan Flushbar sukses
      Flushbar(
        message: "Login successful",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.check, color: Colors.white),
      ).show(context);

      // Delay untuk memberi waktu Flushbar muncul sebelum navigasi
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      // Jika login gagal, tampilkan Flushbar error
      Flushbar(
        message: result['message'],
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        icon: const Icon(Icons.error, color: Colors.white),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar (Logo atau Header)
                Center(
                  child: Image.asset(
                    'assets/images/masuk.jpg', // Ganti dengan path gambar Anda
                    height: 150,
                  ),
                ),
                const SizedBox(height: 24),
                // Teks Header
                const Text(
                  'Selamat Datang!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk melanjutkan.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),
                // Form Input Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Form Input Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFFB71C1C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Opsi Daftar Akun
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () {
                        // Arahkan ke halaman register
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text('Daftar di sini'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
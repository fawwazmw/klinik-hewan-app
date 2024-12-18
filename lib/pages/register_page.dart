import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Pastikan ini sesuai dengan lokasi file api_service.dart

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk TextField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false; // Indikator loading saat melakukan request

  // Fungsi untuk handle registrasi
  void _register() async {
    // Validasi form
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      Flushbar(
        message: "Harap lengkapi semua kolom.",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    // Cek apakah password dan konfirmasi password sama
    if (_passwordController.text != _confirmPasswordController.text) {
      Flushbar(
        message: "Kata sandi dan konfirmasi kata sandi tidak cocok.",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Panggil fungsi registrasi dari API
    var result = await register(
      _nameController.text,
      _emailController.text,
      _phoneController.text,
      _passwordController.text,
      _confirmPasswordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    // Periksa apakah registrasi berhasil
    if (result['success']) {
      // Jika berhasil, tampilkan Flushbar sukses
      Flushbar(
        message: "Registrasi berhasil!",
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ).show(context);

      // Delay untuk memberi waktu Flushbar muncul sebelum navigasi
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, '/login_screen');
      });
    } else {
      // Jika gagal, tampilkan Flushbar error
      String errorMessage = result['message'] ?? "Terjadi kesalahan. Silakan coba lagi.";
      Flushbar(
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/masuk.jpg', // Gambar ilustrasi
                height: 200,
              ),
              const SizedBox(height: 16),
              const Text(
                'Daftar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(Icons.person, 'Nama Lengkap', _nameController),
              _buildTextField(Icons.phone, 'Nomor Telp', _phoneController),
              _buildTextField(Icons.email, 'Alamat Email', _emailController),
              _buildTextField(Icons.lock, 'Kata Sandi', _passwordController, isPassword: true),
              _buildTextField(Icons.lock, 'Konfirmasi Kata Sandi', _confirmPasswordController, isPassword: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                  'Daftar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dengan masuk dan mendaftar, anda menyetujui\nKetentuan Layanan dan Kebijakan Privasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk membuat text field
  Widget _buildTextField(IconData icon, String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.red),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
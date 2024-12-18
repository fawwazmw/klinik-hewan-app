import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

// Fungsi untuk melakukan register
Future<Map<String, dynamic>> register(String name, String email, String mobileNumber, String password, String passwordConfirmation) async {
  final response = await http.post(
    Uri.parse('$apiUrl/register'),
    body: {
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
    },
  ).timeout(const Duration(seconds: 10));

  if (response.statusCode == 201) {
    var data = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', data['token']);

    return {
      'success': true,
      'message': 'Registration successful',
      'token': data['token'],
    };
  } else {
    return {
      'success': false,
      'message': 'Failed to register',
    };
  }
}

// Fungsi untuk mengambil data pengguna yang sudah login
Future<Map<String, dynamic>> getUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  if (token == null) {
    return {
      'success': false,
      'message': 'No token found',
    };
  }

  final response = await http.get(
    Uri.parse('$apiUrl/user'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      'success': true,
      'user': data,
    };
  } else {
    return {
      'success': false,
      'message': 'Failed to fetch user data',
    };
  }
}

// General function for API request with Bearer token
Future<Map<String, dynamic>> _apiRequest(String method, String endpoint, {Map<String, dynamic>? body}) async {
  String? token = await _getToken();

  if (token == null) {
    return {
      'success': false,
      'message': 'No token found',
    };
  }

  var headers = {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  http.Response response;

  // Handling different HTTP methods
  if (method == 'GET') {
    response = await http.get(Uri.parse('$apiUrl/$endpoint'), headers: headers);
  } else if (method == 'POST') {
    response = await http.post(Uri.parse('$apiUrl/$endpoint'), headers: headers, body: json.encode(body));
  } else if (method == 'PUT') {
    response = await http.put(Uri.parse('$apiUrl/$endpoint'), headers: headers, body: json.encode(body));
  } else if (method == 'DELETE') {
    response = await http.delete(Uri.parse('$apiUrl/$endpoint'), headers: headers);
  } else {
    return {'success': false, 'message': 'Invalid HTTP method'};
  }

  if (response.statusCode == 200 || response.statusCode == 201) {
    return {
      'success': true,
      'data': json.decode(response.body),
    };
  } else {
    return {
      'success': false,
      'message': response.body,
    };
  }
}

// Function to get the authorization token from SharedPreferences
Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

// CRUD Functions for `hewan`:

// 1. Create (POST) - Add a new "hewan"
Future<Map<String, dynamic>> createHewan(Map<String, dynamic> hewanData) async {
  return await _apiRequest('POST', 'hewan', body: hewanData);
}

// 2. Read (GET) - Get all "hewan"
Future<Map<String, dynamic>> getAllHewan() async {
  return await _apiRequest('GET', 'hewan');
}

// 3. Update (PUT) - Update a specific "hewan"
Future<Map<String, dynamic>> updateHewan(int id, Map<String, dynamic> updatedHewanData) async {
  return await _apiRequest('PUT', 'hewan/$id', body: updatedHewanData);
}

// 4. Delete (DELETE) - Delete a specific "hewan"
Future<Map<String, dynamic>> deleteHewan(int id) async {
  return await _apiRequest('DELETE', 'hewan/$id');
}

// CRUD Functions for `kesehatan`:

// 1. Create (POST) - Add a new "kesehatan"
Future<Map<String, dynamic>> createKesehatan(Map<String, dynamic> kesehatanData) async {
  return await _apiRequest('POST', 'kesehatan', body: kesehatanData);
}

// 2. Read (GET) - Get all "kesehatan"
Future<Map<String, dynamic>> getAllKesehatan() async {
  return await _apiRequest('GET', 'kesehatan');
}

// 3. Update (PUT) - Update a specific "kesehatan"
Future<Map<String, dynamic>> updateKesehatan(int id, Map<String, dynamic> updatedKesehatanData) async {
  return await _apiRequest('PUT', 'kesehatan/$id', body: updatedKesehatanData);
}

// 4. Delete (DELETE) - Delete a specific "kesehatan"
Future<Map<String, dynamic>> deleteKesehatan(int id) async {
  return await _apiRequest('DELETE', 'kesehatan/$id');
}

// CRUD Functions for `perkembangan`:

// 1. Create (POST) - Add a new "perkembangan"
Future<Map<String, dynamic>> createPerkembangan(Map<String, dynamic> perkembanganData) async {
  return await _apiRequest('POST', 'perkembangan', body: perkembanganData);
}

// 2. Read (GET) - Get all "perkembangan"
Future<Map<String, dynamic>> getAllPerkembangan() async {
  return await _apiRequest('GET', 'perkembangan');
}

// 3. Update (PUT) - Update a specific "perkembangan"
Future<Map<String, dynamic>> updatePerkembangan(int id, Map<String, dynamic> updatedPerkembanganData) async {
  return await _apiRequest('PUT', 'perkembangan/$id', body: updatedPerkembanganData);
}

// 4. Delete (DELETE) - Delete a specific "perkembangan"
Future<Map<String, dynamic>> deletePerkembangan(int id) async {
  return await _apiRequest('DELETE', 'perkembangan/$id');
}

// CRUD Functions for `obat`:

// 1. Create (POST) - Add a new "obat"
Future<Map<String, dynamic>> createObat(Map<String, dynamic> obatData) async {
  return await _apiRequest('POST', 'obat', body: obatData);
}

// 2. Read (GET) - Get all "obat"
Future<Map<String, dynamic>> getAllObat() async {
  return await _apiRequest('GET', 'obat');
}

// 3. Update (PUT) - Update a specific "obat"
Future<Map<String, dynamic>> updateObat(int id, Map<String, dynamic> updatedObatData) async {
  return await _apiRequest('PUT', 'obat/$id', body: updatedObatData);
}

// 4. Delete (DELETE) - Delete a specific "obat"
Future<Map<String, dynamic>> deleteObat(int id) async {
  return await _apiRequest('DELETE', 'obat/$id');
}

// CRUD Functions for `dokter`:

// 1. Create (POST) - Add a new "dokter"
Future<Map<String, dynamic>> createDokter(Map<String, dynamic> dokterData) async {
  return await _apiRequest('POST', 'dokter', body: dokterData);
}

// 2. Read (GET) - Get all "dokter"
Future<Map<String, dynamic>> getAllDokter() async {
  return await _apiRequest('GET', 'dokter');
}

// 3. Update (PUT) - Update a specific "dokter"
Future<Map<String, dynamic>> updateDokter(int id, Map<String, dynamic> updatedDokterData) async {
  return await _apiRequest('PUT', 'dokter/$id', body: updatedDokterData);
}

// 4. Delete (DELETE) - Delete a specific "dokter"
Future<Map<String, dynamic>> deleteDokter(int id) async {
  return await _apiRequest('DELETE', 'dokter/$id');
}

import 'package:flutter/material.dart';

class TumbuhKembangPage extends StatefulWidget {
  const TumbuhKembangPage({super.key});

  @override
  _TumbuhKembangPageState createState() => _TumbuhKembangPageState();
}

class _TumbuhKembangPageState extends State<TumbuhKembangPage> {
  final TextEditingController beratController = TextEditingController();
  final TextEditingController tinggiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tumbuh Kembang"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(
                        'assets/dog.jpg'), // Ganti dengan path gambar Anda
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "JACKSON",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Icon(Icons.male, color: Colors.blue, size: 20),
                        ],
                      ),
                      Text(
                        "2 th",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "Brown",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24.0),

            // Grafik Tumbuh Kembang
            const Text(
              "Tumbuh Kembang",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child: Text(
                    "Grafik Placeholder"), // Ganti dengan implementasi grafik
              ),
            ),

            const SizedBox(height: 24.0),

            // Input Berat dan Tinggi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Input Berat
                Expanded(
                  child: Column(
                    children: [
                      const Text("Berat", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.line_weight, color: Colors.red),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                controller: beratController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "--",
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DropdownButton<String>(
                              value: "Kg",
                              underline: const SizedBox(),
                              items: ["Kg"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Logika untuk mencatat berat
                          print("Berat dicatat: ${beratController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Catat"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16.0),

                // Input Tinggi
                Expanded(
                  child: Column(
                    children: [
                      const Text("Tinggi", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.height, color: Colors.red),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: TextField(
                                controller: tinggiController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "--",
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            DropdownButton<String>(
                              value: "M",
                              underline: const SizedBox(),
                              items: ["M"].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Logika untuk mencatat tinggi
                          print("Tinggi dicatat: ${tinggiController.text}");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Catat"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

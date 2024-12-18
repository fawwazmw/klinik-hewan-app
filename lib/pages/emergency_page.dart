import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Services'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'In case of an emergency, contact the following services:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            EmergencyButton(
              icon: Icons.local_hospital,
              label: 'Call Ambulance',
              onTap: () {
                _launchPhoneURL('tel:112'); // Nomor darurat Ambulance
              },
            ),
            EmergencyButton(
              icon: Icons.local_fire_department,
              label: 'Call Fire Department',
              onTap: () {
                _launchPhoneURL('tel:113'); // Nomor darurat Pemadam Kebakaran
              },
            ),
            EmergencyButton(
              icon: Icons.security,
              label: 'Call Police',
              onTap: () {
                _launchPhoneURL('tel:110'); // Nomor darurat Polisi
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to additional resources or help center
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color(0xFFB71C1C),
              ),
              child: Text(
                'Other Emergency Resources',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuka aplikasi telepon dan melakukan panggilan
  void _launchPhoneURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class EmergencyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const EmergencyButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(icon, color: Color(0xFFB71C1C), size: 30),
        title: Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFFB71C1C)),
        onTap: onTap,
      ),
    );
  }
}

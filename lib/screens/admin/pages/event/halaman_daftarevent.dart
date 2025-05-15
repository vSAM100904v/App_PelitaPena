import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';
import 'halaman_detailevent.dart';
import 'halaman_editevent.dart';

class HalamanDaftarevent extends StatelessWidget {
  const HalamanDaftarevent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Event'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HalamanEditevent(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Beranda.primaryBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(
                  Icons.event,
                  size: 80,
                  color: Beranda.primaryBlue.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seminar Pencegahan Kekerasan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(Icons.calendar_today, 'Tanggal', '2023-06-15'),
            _buildInfoItem(Icons.access_time, 'Waktu', '09:00 - 12:00'),
            _buildInfoItem(
              Icons.location_on,
              'Lokasi',
              'Aula Kantor Dinas Sosial',
            ),
            _buildInfoItem(Icons.people, 'Kuota', '50 orang'),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Seminar ini bertujuan untuk memberikan edukasi kepada masyarakat tentang pencegahan kekerasan terhadap perempuan dan anak. Seminar akan diisi oleh narasumber yang kompeten di bidangnya.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Narasumber',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            _buildNarasumberItem('Dr. Siti Aminah', 'Psikolog Anak'),
            _buildNarasumberItem(
              'Budi Santoso, S.H.',
              'Pengacara Hukum Keluarga',
            ),
            _buildNarasumberItem(
              'Dra. Ratna Dewi',
              'Aktivis Perlindungan Perempuan',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanDetailevent(),
                    ),
                  );
                },
                icon: const Icon(Icons.app_registration),
                label: const Text(
                  'Daftar Sekarang',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Beranda.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildNarasumberItem(String name, String role) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Beranda.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Beranda.primaryBlue),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                role,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

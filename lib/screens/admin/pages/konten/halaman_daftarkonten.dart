import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';
import 'halaman_detailkonten.dart';
import 'halaman_editkonten.dart';

class HalamanDaftarkonten extends StatelessWidget {
  const HalamanDaftarkonten({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Konten'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HalamanEditkonten(),
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
                  Icons.article,
                  size: 80,
                  color: Beranda.primaryBlue.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Beranda.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Artikel',
                    style: TextStyle(
                      color: Beranda.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Text(
                  '2023-06-01',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Cara Melaporkan Kekerasan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pendahuluan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kekerasan terhadap perempuan dan anak masih menjadi masalah serius di masyarakat kita. Banyak korban yang tidak tahu bagaimana cara melaporkan kejadian kekerasan yang mereka alami. Artikel ini akan memberikan panduan langkah demi langkah tentang cara melaporkan kekerasan.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Langkah-langkah Melaporkan Kekerasan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Beranda.secondaryBlue,
              ),
            ),
            const SizedBox(height: 8),
            _buildStep(
              '1',
              'Cari tempat yang aman',
              'Pastikan Anda berada di tempat yang aman sebelum melaporkan kejadian. Jika perlu, mintalah bantuan dari orang terdekat atau hubungi hotline darurat.',
            ),
            _buildStep(
              '2',
              'Dokumentasikan bukti',
              'Jika memungkinkan, dokumentasikan bukti kekerasan seperti foto luka, rekaman suara, atau pesan ancaman.',
            ),
            _buildStep(
              '3',
              'Hubungi pihak berwenang',
              'Laporkan kejadian ke polisi terdekat atau hubungi nomor darurat 112. Anda juga dapat menghubungi hotline khusus kekerasan terhadap perempuan dan anak di 0895626467202.',
            ),
            _buildStep(
              '4',
              'Dapatkan pendampingan hukum',
              'Carilah bantuan hukum dari lembaga bantuan hukum atau organisasi perlindungan perempuan dan anak.',
            ),
            _buildStep(
              '5',
              'Dapatkan dukungan psikologis',
              'Kekerasan dapat meninggalkan trauma psikologis. Carilah bantuan konseling atau terapi untuk membantu pemulihan.',
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
                      builder: (context) => const HalamanDetailkonten(),
                    ),
                  );
                },
                icon: const Icon(Icons.comment),
                label: const Text(
                  'Lihat Komentar',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Beranda.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

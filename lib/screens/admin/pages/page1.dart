import 'package:pa2_kelompok07/screens/admin/heading2.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Donasi/donasi.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/kategorikekerasana.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/konten.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:pa2_kelompok07/screens/admin/heading.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman 1'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Halaman - halaman dalam Admin Mobile',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),

            // ElevatedButton(
            //   onPressed: () {
            //     // Navigasi ke halaman 2
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Page2()),
            //     );
            //   },
            //   child: const Text('Pergi ke Halaman 2'),
            // ),
            // DITAMBAHKAN: SizedBox untuk memberikan jarak antar tombol

            // const SizedBox(height: 15),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigasi ke halaman 2
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const TambahKontenPage(),
            //       ),
            //     );
            //   },
            //   child: const Text('Pergi ke Halaman 2'),
            // ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Beranda()),
                );
              },
              child: const Text('Beranda Admin'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Konten()),
                );
              },
              child: const Text('Konten Admin'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Konten()),
                );
              },
              child: const Text('Daftar Laporan'),
            ),
            const SizedBox(height: 15),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Konten()),
                );
              },
              child: const Text('Event'),
            ),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Donasi()),
                );
              },
              child: const Text('Donasi'),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Heading()),
                );
              },
              child: const Text('Heading lengkap'),
            ),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Heading2()),
                );
              },
              child: const Text('Heading 2 lengkap'),
            ),

            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman 2
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KategoriKekerasan(),
                  ),
                );
              },
              child: const Text('Kategori Kekerasan'),
            ),
          ],
        ),
      ),
    );
  }
}

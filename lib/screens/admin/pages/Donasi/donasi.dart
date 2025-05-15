import 'package:pa2_kelompok07/screens/admin/pages/Donasi/daftardonasi.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Donasi/createdonasi.dart';
import 'package:pa2_kelompok07/screens/admin/pages/Donasi/halaman_donasi.dart';
import 'package:flutter/material.dart';

class Donasi extends StatelessWidget {
  const Donasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Konten'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15),

              // Tambahkan Konten
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DaftarDonasi(),
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => const Createdonasi(),
                    ),
                  );
                },
                child: const Text('Buat Donasi'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanDonasi(),
                    ),
                  );
                },
                child: const Text('halaman Buat Donasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

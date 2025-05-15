import 'package:pa2_kelompok07/screens/admin/pages/konten/detailkonten.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/editkonten.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/tambahkonten.dart';
import 'package:pa2_kelompok07/screens/admin/pages/konten/daftarkonten.dart';

class Konten extends StatelessWidget {
  const Konten({super.key});

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
              // Daftar Konten
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Daftarkonten(),
                    ),
                  );
                },
                child: const Text('Daftar Konten'),
              ),

              const SizedBox(height: 15),

              // Tambahkan Konten
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahKontenPage(),
                    ),
                  );
                },
                child: const Text('Tambah Konten'),
              ),

              const SizedBox(height: 15),

              // Edit Konten
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditKontenScreen(),
                    ),
                  );
                },
                child: const Text('Edit Konten'),
              ),

              const SizedBox(height: 15),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailKonten(),
                    ),
                  );
                },
                child: const Text('Detail Konten'),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

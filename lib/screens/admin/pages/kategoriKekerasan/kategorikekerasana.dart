import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/createkategori.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/daftarkategorikekerasan.dart';
import 'package:pa2_kelompok07/screens/admin/pages/kategoriKekerasan/halamanbaru_kategori.dart';
import 'package:flutter/material.dart';

class KategoriKekerasan extends StatelessWidget {
  const KategoriKekerasan({super.key});

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
                      builder: (context) => const DaftarKategoriKekerasan(),
                    ),
                  );
                },
                child: const Text('Daftar Kategori'),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateKategori(),
                    ),
                  );
                },
                child: const Text('CreateKategori'),
              ),

              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman 2
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HalamanbaruKategori(),
                    ),
                  );
                },
                child: const Text('HALAMAN BARU'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

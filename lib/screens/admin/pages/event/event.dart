import 'package:pa2_kelompok07/screens/admin/pages/event/detailevent.dart';
import 'package:pa2_kelompok07/screens/admin/pages/event/editevent.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/screens/admin/pages/event/tambahevent.dart';
import 'package:pa2_kelompok07/screens/admin/pages/event/daftarevent.dart';

class Event extends StatelessWidget {
  const Event({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Event'),
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
              // Daftar Event
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Daftar Event
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Daftarevent(),
                    ),
                  );
                },
                child: const Text('Daftar Event'),
              ),

              const SizedBox(height: 15),

              // Tambahkan Event
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Tambah Event
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahEventPage(),
                    ),
                  );
                },
                child: const Text('Tambah Event'),
              ),

              const SizedBox(height: 15),

              // Edit Event
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Edit Event
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditEventScreen(),
                    ),
                  );
                },
                child: const Text('Edit Event'),
              ),

              const SizedBox(height: 15),

              // Detail Event
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Detail Event
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailEvent(),
                    ),
                  );
                },
                child: const Text('Detail Event'),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

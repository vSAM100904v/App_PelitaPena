import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';

class HalamanEditkonten extends StatefulWidget {
  const HalamanEditkonten({Key? key}) : super(key: key);

  @override
  State<HalamanEditkonten> createState() => _EditKontenState();
}

class _EditKontenState extends State<HalamanEditkonten> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _judulController = TextEditingController(
    text: 'Cara Melaporkan Kekerasan',
  );
  final TextEditingController _jenisController = TextEditingController(
    text: 'Artikel',
  );
  final TextEditingController _tanggalController = TextEditingController(
    text: '2023-06-01',
  );
  final TextEditingController _isiController = TextEditingController(
    text:
        'Kekerasan terhadap perempuan dan anak masih menjadi masalah serius di masyarakat kita. Banyak korban yang tidak tahu bagaimana cara melaporkan kejadian kekerasan yang mereka alami. Artikel ini akan memberikan panduan langkah demi langkah tentang cara melaporkan kekerasan.',
  );

  @override
  void dispose() {
    _judulController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Konten'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Konten',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Beranda.secondaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Konten',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Jenis Konten',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: 'Artikel',
                items: const [
                  DropdownMenuItem(value: 'Artikel', child: Text('Artikel')),
                  DropdownMenuItem(value: 'Video', child: Text('Video')),
                  DropdownMenuItem(
                    value: 'Infografis',
                    child: Text('Infografis'),
                  ),
                ],
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis konten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tanggalController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isiController,
                decoration: const InputDecoration(
                  labelText: 'Isi Konten',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi konten tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus konten ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Konten berhasil dihapus',
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Hapus Konten'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Konten berhasil diperbarui'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Simpan Perubahan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

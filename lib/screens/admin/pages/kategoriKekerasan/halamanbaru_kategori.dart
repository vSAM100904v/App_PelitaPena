import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';

class HalamanbaruKategori extends StatelessWidget {
  const HalamanbaruKategori({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'Kekerasan Fisik',
        'icon': Icons.personal_injury,
        'description':
            'Kekerasan yang mengakibatkan rasa sakit, jatuh sakit, atau luka berat.',
        'examples': [
          'Memukul',
          'Menampar',
          'Mencekik',
          'Menendang',
          'Menyundut dengan rokok',
        ],
      },
      {
        'title': 'Kekerasan Psikis',
        'icon': Icons.psychology,
        'description':
            'Perbuatan yang mengakibatkan ketakutan, hilangnya rasa percaya diri, dan/atau penderitaan psikis berat.',
        'examples': [
          'Intimidasi',
          'Penghinaan',
          'Isolasi sosial',
          'Ancaman',
          'Kontrol berlebihan',
        ],
      },
      {
        'title': 'Kekerasan Seksual',
        'icon': Icons.warning_amber,
        'description':
            'Pemaksaan hubungan seksual yang dilakukan terhadap orang yang menetap dalam lingkup rumah tangga atau terhadap seseorang.',
        'examples': [
          'Pemerkosaan',
          'Pelecehan seksual',
          'Eksploitasi seksual',
          'Pemaksaan hubungan seksual',
          'Pemaksaan perkawinan',
        ],
      },
      {
        'title': 'Kekerasan Ekonomi',
        'icon': Icons.attach_money,
        'description':
            'Penelantaran atau membatasi seseorang untuk bekerja yang layak di dalam atau di luar rumah.',
        'examples': [
          'Tidak memberikan nafkah',
          'Melarang bekerja',
          'Mengambil harta tanpa izin',
          'Memaksa bekerja',
          'Mengontrol keuangan secara berlebihan',
        ],
      },
      {
        'title': 'Kekerasan Verbal',
        'icon': Icons.record_voice_over,
        'description':
            'Penggunaan kata-kata kasar yang menyakiti perasaan dan merendahkan harga diri seseorang.',
        'examples': [
          'Membentak',
          'Memaki',
          'Menghina',
          'Mengancam',
          'Merendahkan',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Kekerasan'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Beranda.primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  category['icon'] as IconData,
                  color: Beranda.primaryBlue,
                ),
              ),
              title: Text(
                category['title'] as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Beranda.secondaryBlue,
                ),
              ),
              subtitle: Text(
                category['description'] as String,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contoh:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Beranda.secondaryBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(
                        (category['examples'] as List).length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(
                                child: Text(category['examples'][i] as String),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Melihat detail ${category['title']}',
                                ),
                              ),
                            );
                          },
                          child: const Text('Pelajari Lebih Lanjut'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

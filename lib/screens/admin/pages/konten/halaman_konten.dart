import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';
import 'halaman_daftarkonten.dart';
// import 'halaman_tambahkonten.dart';

class HalamanKonten extends StatefulWidget {
  const HalamanKonten({Key? key}) : super(key: key);

  @override
  State<HalamanKonten> createState() => _KontenState();
}

class _KontenState extends State<HalamanKonten> {
  final List<Map<String, dynamic>> _contents = [
    {
      'title': 'Cara Melaporkan Kekerasan',
      'date': '2023-06-01',
      'type': 'Artikel',
      'image': Icons.article,
    },
    {
      'title': 'Mengenali Tanda-tanda Kekerasan',
      'date': '2023-06-05',
      'type': 'Video',
      'image': Icons.video_library,
    },
    {
      'title': 'Hak-hak Korban Kekerasan',
      'date': '2023-06-10',
      'type': 'Infografis',
      'image': Icons.insert_chart,
    },
    {
      'title': 'Dampak Psikologis Kekerasan',
      'date': '2023-06-15',
      'type': 'Artikel',
      'image': Icons.article,
    },
  ];

  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Artikel', 'Video', 'Infografis'];

  List<Map<String, dynamic>> get _filteredContents {
    if (_selectedFilter == 'Semua') {
      return _contents;
    }
    return _contents
        .where((content) => content['type'] == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konten'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Jenis Konten',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Beranda.secondaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        _filters.map((filter) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                }
                              },
                              selectedColor: Beranda.primaryBlue,
                              labelStyle: TextStyle(
                                color:
                                    _selectedFilter == filter
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child:
                _filteredContents.isEmpty
                    ? const Center(child: Text('Tidak ada konten'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredContents.length,
                      itemBuilder: (context, index) {
                        final content = _filteredContents[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const HalamanDaftarkonten(),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Beranda.primaryBlue.withOpacity(0.2),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      content['image'] as IconData,
                                      size: 50,
                                      color: Beranda.primaryBlue.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            content['type'] as String,
                                            style: TextStyle(
                                              color: Beranda.primaryBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            content['date'] as String,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        content['title'] as String,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Beranda.secondaryBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                          const HalamanDaftarkonten(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.visibility,
                                              size: 16,
                                            ),
                                            label: const Text(
                                              'Baca Selengkapnya',
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Beranda.primaryBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Beranda.primaryBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HalamanDaftarkonten(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

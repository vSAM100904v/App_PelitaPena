import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';

class HalamanJanjitemu extends StatefulWidget {
  const HalamanJanjitemu({Key? key}) : super(key: key);

  @override
  State<HalamanJanjitemu> createState() => _JanjiTemuState();
}

class _JanjiTemuState extends State<HalamanJanjitemu> {
  final List<Map<String, dynamic>> _appointments = [
    {
      'name': 'Siti Aminah',
      'date': '2023-06-10',
      'time': '09:00 - 10:00',
      'status': 'Menunggu',
      'type': 'Konsultasi Hukum',
    },
    {
      'name': 'Budi Santoso',
      'date': '2023-06-12',
      'time': '13:00 - 14:00',
      'status': 'Dikonfirmasi',
      'type': 'Konseling Psikologi',
    },
    {
      'name': 'Dewi Lestari',
      'date': '2023-06-15',
      'time': '10:00 - 11:00',
      'status': 'Selesai',
      'type': 'Pendampingan Kasus',
    },
    {
      'name': 'Ahmad Rizki',
      'date': '2023-06-18',
      'time': '14:00 - 15:00',
      'status': 'Dibatalkan',
      'type': 'Konsultasi Hukum',
    },
  ];

  String _selectedFilter = 'Semua';
  final List<String> _filters = [
    'Semua',
    'Menunggu',
    'Dikonfirmasi',
    'Selesai',
    'Dibatalkan',
  ];

  List<Map<String, dynamic>> get _filteredAppointments {
    if (_selectedFilter == 'Semua') {
      return _appointments;
    }
    return _appointments
        .where((appointment) => appointment['status'] == _selectedFilter)
        .toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.orange;
      case 'Dikonfirmasi':
        return Colors.green;
      case 'Selesai':
        return Beranda.primaryBlue;
      case 'Dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Buat Janji Temu Baru'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Waktu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Jenis Konsultasi',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Konsultasi Hukum',
                        child: Text('Konsultasi Hukum'),
                      ),
                      DropdownMenuItem(
                        value: 'Konseling Psikologi',
                        child: Text('Konseling Psikologi'),
                      ),
                      DropdownMenuItem(
                        value: 'Pendampingan Kasus',
                        child: Text('Pendampingan Kasus'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Janji temu berhasil dibuat')),
                  );
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Janji Temu'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Status',
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
                _filteredAppointments.isEmpty
                    ? const Center(child: Text('Tidak ada janji temu'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _filteredAppointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      appointment['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Beranda.secondaryBlue,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          appointment['status'],
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _getStatusColor(
                                            appointment['status'],
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        appointment['status'],
                                        style: TextStyle(
                                          color: _getStatusColor(
                                            appointment['status'],
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      appointment['date'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      appointment['time'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      appointment['type'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Detail janji temu'),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.visibility,
                                        size: 16,
                                      ),
                                      label: const Text('Lihat Detail'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Beranda.primaryBlue,
                                      ),
                                    ),
                                  ],
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
        onPressed: _showAddAppointmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

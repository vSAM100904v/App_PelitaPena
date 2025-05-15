import 'package:flutter/material.dart';
import '../beranda/admin_dashboard.dart';

class HalamanDetailkonten extends StatefulWidget {
  const HalamanDetailkonten({Key? key}) : super(key: key);

  @override
  State<HalamanDetailkonten> createState() => _DetailKontenState();
}

class _DetailKontenState extends State<HalamanDetailkonten> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {
      'name': 'Siti Aminah',
      'date': '2023-06-02',
      'comment': 'Artikel ini sangat membantu. Terima kasih atas informasinya.',
    },
    {
      'name': 'Budi Santoso',
      'date': '2023-06-03',
      'comment': 'Saya akan membagikan artikel ini ke teman-teman saya.',
    },
    {
      'name': 'Dewi Lestari',
      'date': '2023-06-05',
      'comment':
          'Apakah ada nomor hotline lain yang bisa dihubungi selain yang disebutkan di artikel?',
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Komentar'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
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
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Beranda.primaryBlue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Beranda.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  comment['date'] as String,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          comment['comment'] as String,
                          style: const TextStyle(height: 1.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Balas komentar'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.reply, size: 16),
                              label: const Text('Balas'),
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    if (_commentController.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Komentar berhasil dikirim'),
                        ),
                      );
                      _commentController.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: Beranda.primaryBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DetailKonten extends StatelessWidget {
  const DetailKonten({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E4374)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Konten',
          style: TextStyle(
            color: Color(0xFF2E4374),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: const NetworkImage(
                'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-4BrnI3yirocxVzGB1nmUAEB8IOBarm.png',
              ),
              radius: 18,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Konten
            const Text(
              'Sosialisasi Kekerasan Terhadap Anak dan Perempuan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4374),
              ),
            ),
            const SizedBox(height: 16),
                        Row(
              children: const [
                Icon(Icons.calendar_today, color: Color(0xFF7AA5D2)),
                SizedBox(width: 8),
                Text(
                  '07 Des 2025 | 10:00 AM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7AA5D2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Penulis / Sumber
            Row(
              children: const [
                Icon(Icons.person, color: Color(0xFF7AA5D2)),
                SizedBox(width: 8),
                Text(
                  'Admin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7AA5D2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Gambar Utama / Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1556484687-30636164638b',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Deskripsi Lengkap
            const Text(
              'Di seluruh dunia, kekerasan terhadap perempuan dan anak adalah masalah serius. Dalam sosialisasi ini, kami akan membahas langkah-langkah pencegahan serta memberikan panduan bagaimana cara menangani situasi kekerasan. Dengan harapan, kita dapat bersama-sama menghentikan segala bentuk kekerasan yang terjadi di sekitar kita.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Tanggal & Waktu


            // Konten Terkait (Optional)
            const Text(
              'Konten Terkait',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4374),
              ),
            ),

            const SizedBox(height: 8),
            _buildRelatedContent(
              title: 'Sosialisasi Pencegahan Kekerasan pada Perempuan',
              date: '03 Des 2025',
              imageUrl:
                  'https://images.unsplash.com/photo-1502980426475-b83966705988',
            ),
                        const SizedBox(height: 8),
            _buildRelatedContent(
              title: 'Sosialisasi Pencegahan Kekerasan pada Perempuan',
              date: '03 Des 2025',
              imageUrl:
                  'https://images.unsplash.com/photo-1502980426475-b83966705988',
            ),
                        const SizedBox(height: 8),
            _buildRelatedContent(
              title: 'Sosialisasi Pencegahan Kekerasan pada Perempuan',
              date: '03 Des 2025',
              imageUrl:
                  'https://images.unsplash.com/photo-1502980426475-b83966705988',
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chat_bubble_outline,
                  color: Color(0xFF7AA5D2),
                  size: 30,
                ),
                onPressed: () {},
              ),
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF7AA5D2),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.home, color: Colors.white, size: 30),
              ),
              IconButton(
                icon: const Icon(
                  Icons.warning_amber_outlined,
                  color: Color(0xFF7AA5D2),
                  size: 30,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedContent({required String title, required String date, required String imageUrl}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF2E4374),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class JanjiTemuBaru extends StatelessWidget {
  const JanjiTemuBaru({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF2E4374)),
          onPressed: () {},
        ),
        title: const Text(
          'PendikaApp',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF7AA5D2),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Pelaporan DPMDPPA',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Jangan lupa selalu semangat 100% tangani kekerasan terhadap perempuan dan anak',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4F9),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  hintText: "Search for something",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          // Header + Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Janji Temu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E4374),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, size: 18),
                      label: const Text("Filters"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7AA5D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.print, size: 18),
                      label: const Text("Ekspor"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7AA5D2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        textStyle: const TextStyle(fontSize: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Table Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: const [
                SizedBox(width: 28),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Pengirim',
                    style: TextStyle(color: Color(0xFF7A7D87), fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Jam Mulai',
                    style: TextStyle(color: Color(0xFF7A7D87), fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Jam Selesai',
                    style: TextStyle(color: Color(0xFF7A7D87), fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(color: Color(0xFF7A7D87), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Scrollable Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildJanjiTemuItem(
                    pengirim: 'Venessa H...',
                    jamMulai: '29 Maret 2025, 15:04',
                    jamSelesai: '29 Maret 2025, 15:04',
                    status: 'Baru',
                  ),
                  _buildJanjiTemuItem(
                    pengirim: 'Samuel M...',
                    jamMulai: '27 Maret 2025, 15:04',
                    jamSelesai: '27 Maret 2025, 17:00',
                    status: 'Baru',
                  ),
                  _buildJanjiTemuItem(
                    pengirim: '001-DPMDP...',
                    jamMulai: '25 Maret 2025, 13:00',
                    jamSelesai: '25 Maret 2025, 16:00',
                    status: 'Baru',
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
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

  Widget _buildJanjiTemuItem({
    required String pengirim,
    required String jamMulai,
    required String jamSelesai,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.radio_button_off, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              pengirim,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Expanded(child: Text(jamMulai, style: const TextStyle(fontSize: 13))),
          Expanded(
            child: Text(jamSelesai, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    color: Color(0xFF2E80CE),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  height: 28,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7AA5D2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Detail',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
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

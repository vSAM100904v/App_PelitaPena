import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../model/content_model.dart';
import '../model/event_model.dart';
import '../screens/event_detail_page.dart';
import '../screens/community_screen.dart';
import '../screens/client/dpmdppa/report_screen.dart';
import '../screens/appointment/appointment_screen.dart';

class CarouselLoading extends StatefulWidget {
  const CarouselLoading({Key? key}) : super(key: key);

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  Future<List<Content>>? futureContents;
  Future<List<Event>>? futureEvents;
  int _currentCarousel = 0;
  final CarouselController _carouselController = CarouselController();

  // Enhanced color palette for better UX
  final Color emergencyColor = const Color(0xFFE53E3E); // Red for emergency
  final Color phoneColor = const Color(
    0xFFFF6B6B,
  ); // Coral pink for phone (matching image)
  final Color formColor = const Color.fromARGB(
    255,
    253,
    161,
    2,
  ); // Changed to orange for form
  final Color chatColor = const Color.fromARGB(
    255,
    90,
    213,
    137,
  ); // Purple for chat
  final Color appointmentColor = const Color.fromARGB(
    255,
    46,
    186,
    214,
  ); // Amber for appointment
  final Color backgroundColor = const Color(0xFFF7FAFC); // Very light gray
  final Color cardBackground = Colors.white;

  @override
  void initState() {
    super.initState();
    futureContents = APIService().fetchContents();
    futureEvents = APIService().fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor =
        screenWidth < 600
            ? 1.0
            : screenWidth < 1200
            ? 2.0
            : 2.5;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 25),

            // Header with emergency info
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 20),
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: emergencyColor.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: emergencyColor.withOpacity(0.3)),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.info_outline, color: emergencyColor, size: 24),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "Butuh Bantuan Segera?",
            //               style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.bold,
            //                 color: emergencyColor,
            //               ),
            //             ),
            //             const SizedBox(height: 4),
            //             Text(
            //               "Pilih cara pelaporan yang paling sesuai dengan situasi Anda",
            //               style: TextStyle(
            //                 fontSize: 13,
            //                 color: Colors.grey[700],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cara Melaporkan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Pilih metode pelaporan yang paling mudah untuk Anda",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),

                  // Special reporting buttons (Phone and Form) - matching the image design
                  Row(
                    children: [
                      Expanded(child: phoneButtonSpecial()),
                      const SizedBox(width: 20),
                      Expanded(child: formButtonSpecial()),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey[300],
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Layanan Lainnya",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Chat button
                  chatButtonEnhanced(),

                  const SizedBox(width: 15),

                  // Appointment button
                  appointmentButtonEnhanced(),
                ],
              ),
            ),
            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildNavigateSection("Informasi dan Berita", scaleFactor),
            ),

            const SizedBox(height: 30),

            // Artikel Carousel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<Content>>(
                future: futureContents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildHorizontalCarouselSkeleton();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return buildCarousel(snapshot.data!, scaleFactor);
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildNavigateSection("Event", scaleFactor),
            ),

            const SizedBox(height: 10),

            // Event List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<List<Event>>(
                future: futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildEventListSkeleton();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return buildEventList(snapshot.data!);
                  } else {
                    return const Text('No events available');
                  }
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Phone button matching the image design with user-friendly enhancements
  Widget phoneButtonSpecial() {
    return Column(
      children: [
        // Circular icon button with enhanced shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: phoneColor,
            boxShadow: [
              BoxShadow(
                color: phoneColor.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () async {
                const url = 'tel:081397739993';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Tidak dapat membuka dialer'),
                      backgroundColor: emergencyColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.phone, color: Colors.white, size: 40),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Rounded rectangular button with enhanced design
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: phoneColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: phoneColor,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () async {
                const url = 'tel:081397739993';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Tidak dapat membuka dialer'),
                      backgroundColor: emergencyColor,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Hubungi kami",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "TERCEPAT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Form button matching the image design with user-friendly enhancements
  Widget formButtonSpecial() {
    return Column(
      children: [
        // Circular icon button with enhanced shadow
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: formColor,
            boxShadow: [
              BoxShadow(
                color: formColor.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 3,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(40),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportScreen()),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Rounded rectangular button with enhanced design
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: formColor.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: formColor,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    const Text(
                      "Ajukan laporan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "DETAIL",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced chat button
  Widget chatButtonEnhanced() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chatColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final userProvider = Provider.of<UserProvider>(
              context,
              listen: false,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => ClientChatPageSelf(
                      userId: userProvider.user?.id.toString() ?? 'admin',
                      userRole: 'client',
                      currentUserName: userProvider.user?.full_name ?? 'Client',
                      userToken: userProvider.userToken ?? '',
                    ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: chatColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: chatColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Konsultasi",
                        style: TextStyle(
                          color: chatColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Diskusi interaktif dengan petugas",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: chatColor, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced appointment button
  Widget appointmentButtonEnhanced() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appointmentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AppointmentPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: appointmentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.event_note,
                    color: appointmentColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Buat Janji Temu",
                        style: TextStyle(
                          color: appointmentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Jadwalkan pertemuan untuk konsultasi mendalam",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: appointmentColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CarouselSlider buildCarousel(List<Content> contents, double scaleFactor) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 220,
        viewportFraction: 0.9,
        autoPlay: true,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarousel = index;
          });
        },
      ),
      items:
          contents.map((content) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Image.network(
                        content.imageContent,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          content.judul,
                          style: TextStyle(
                            fontSize: 14 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget buildNavigateSection(String title, double scaleFactor) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18 * scaleFactor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CommunityPage()),
            );
          },
          child: Text(
            "Lihat semua",
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 14 * scaleFactor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildHorizontalCarouselSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Widget buildEventListSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder:
              (_, index) => Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
        ),
      ),
    );
  }

  Widget buildEventList(List<Event> events) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(event: event),
                ),
              );
            },
            child: Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      event.thumbnailEvent,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 160,
                    ),
                  ),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      event.namaEvent,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

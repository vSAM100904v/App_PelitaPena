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

  // Softer color palette with less contrast
  final Color primaryColor = const Color(0xFF6B7DB3); // Softer indigo
  final Color phoneColor = const Color(0xFFE57373); // Softer pink
  final Color formColor = const Color(0xFFFFB74D); // Softer orange
  final Color chatColor = const Color(0xFF4DB6AC); // Softer teal
  final Color appointmentColor = const Color(0xFF64B5F6); // Softer blue
  final Color backgroundColor = const Color(0xFFF5F7FA); // Light blue-gray

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
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Removed star icon as requested
                  Text(
                    "Layanan Utama",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Main service cards - taller and slightly wider
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12, // Reduced from 15 to make cards wider
                    mainAxisSpacing: 12, // Reduced from 15 to make cards wider
                    childAspectRatio: 0.85, // Made cards taller (was 1.0)
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      layananCard(
                        "Laporkan via telepon",
                        Icons.phone_in_talk,
                        phoneColor,
                        () async {
                          const url = 'tel:081397739993';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Tidak dapat membuka dialer'),
                              ),
                            );
                          }
                        },
                      ),
                      layananCard(
                        "Laporkan via form",
                        Icons.assignment,
                        formColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReportScreen(),
                            ),
                          );
                        },
                      ),
                      layananCard("Chat langsung", Icons.chat, chatColor, () {
                        final userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ClientChatPageSelf(
                                  userId:
                                      userProvider.user?.id.toString() ??
                                      'admin',
                                  userRole: 'client',
                                  currentUserName:
                                      userProvider.user?.full_name ?? 'Client',
                                  userToken: userProvider.userToken ?? '',
                                ),
                          ),
                        );
                      }),
                      layananCard(
                        "Janji temu",
                        Icons.event_note,
                        appointmentColor,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AppointmentPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: buildNavigateSection("Informasi dan Berita", scaleFactor),
            ),

            const SizedBox(height: 10),

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
                    color: Colors.grey.withOpacity(
                      0.2,
                    ), // Reduced shadow opacity
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
              color: primaryColor,
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
                    color: Colors.grey.withOpacity(
                      0.2,
                    ), // Reduced shadow opacity
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
                          Colors.black.withOpacity(
                            0.6,
                          ), // Slightly reduced opacity
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

// Enhanced service card - taller and with softer colors
Widget layananCard(
  String title,
  IconData icon,
  Color color,
  VoidCallback onTap,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.3), // Reduced shadow opacity
          blurRadius: 10,
          spreadRadius: 1,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Material(
      color: color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with subtle background
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 34,
                ), // Slightly larger icon
              ),
              const SizedBox(height: 20), // Increased spacing
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              // Extra space at bottom to make card appear taller
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    ),
  );
}

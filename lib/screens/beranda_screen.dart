import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/logger/text_logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pa2_kelompok07/carousel/carousel_loading.dart';
import 'package:pa2_kelompok07/styles/color.dart';

import '../provider/user_provider.dart';
import 'client/dpmdppa/report_screen.dart';
import '../screens/profile/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TextLogger {
  late var width = MediaQuery.sizeOf(context).width;
  late var height = MediaQuery.sizeOf(context).height;

  final CarouselController carouselController = CarouselController();

  // Method untuk membuka WhatsApp
  Future<void> _openWhatsApp() async {
    final String phoneNumber = '6281360681103';
    final String message = 'Halo, saya membutuhkan bantuan.';

    // URL untuk WhatsApp
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}',
    );

    try {
      bool didLaunch = await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
      if (!didLaunch) {
        debugLog('Gagal membuka WhatsApp: $whatsappUri');
        // Fallback ke browser jika WhatsApp tidak terinstall
        await launchUrl(whatsappUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugLog('Exception saat membuka WhatsApp: $e');
    }
  }

  // Method untuk membuka telepon
  Future<void> _openPhone() async {
    final Uri telUri = Uri(scheme: 'tel', path: '6281360681103');
    try {
      bool didLaunch = await launchUrl(
        telUri,
        mode: LaunchMode.platformDefault,
      );
      if (!didLaunch) {
        debugLog('Gagal membuka dialer: $telUri');
      }
    } catch (e) {
      debugLog('Exception saat membuka dialer: $e');
    }
  }

  // Method untuk menampilkan dialog pilihan kontak
  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(height: 20),

                // WhatsApp Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.chat,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'WhatsApp',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: const Text('6281360681103'),
                  onTap: () {
                    Navigator.pop(context);
                    _openWhatsApp();
                  },
                ),

                const Divider(),

                // Phone Option
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    'Telepon',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: const Text('6281360681103'),
                  onTap: () {
                    Navigator.pop(context);
                    _openPhone();
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColor.descColor,
                  ),
                ),
                Text(
                  userProvider.isLoggedIn
                      ? "${userProvider.user?.full_name}"
                      : "Guest",
                  style: TextStyle(fontSize: 16, color: AppColor.descColor),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon Notifikasi
                Consumer<UserProvider>(
                  builder:
                      (context, provider, _) => Badge(
                        label: Text(provider.unreadCount.toString()),
                        isLabelVisible: provider.unreadCount > 0,
                        child: IconButton(
                          icon: const Icon(Icons.notifications),
                          color: AppColors.white,
                          onPressed:
                              () => Navigator.of(
                                context,
                              ).pushNamed('/notifikasi'),
                        ),
                      ),
                ),

                // Icon Profile/Akun
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  color: AppColors.white,
                  onPressed: () => Navigator.of(context).pushNamed('/profile'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
          ),
          const CarouselLoading(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColor.primaryColor,
      //   tooltip: 'Hubungi Kami',
      //   onPressed: _showContactOptions,
      //   child: const Icon(Icons.phone, color: Colors.white, size: 28),
      // ),
    );
  }
}

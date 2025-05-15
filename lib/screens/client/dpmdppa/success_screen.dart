import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/navigationBar/bottom_bar.dart';
import 'package:pa2_kelompok07/screens/appointment/appointment_screen.dart';
import 'package:pa2_kelompok07/screens/beranda_screen.dart';
import 'package:pa2_kelompok07/screens/client/dpmdppa/report_screen.dart';
import 'package:pa2_kelompok07/screens/profile/profile_screen.dart';

import '../../../styles/color.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.check_circle, size: 200, color: AppColor.primaryColor),
            const SizedBox(height: 20),
            const Text(
              'Laporan Terkirim',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Terima kasih atas laporan Anda. Petugas kami akan menghubungi Anda selambatnya 3 x 24 jam.',
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Cek notifikasi untuk memantau perkembangan laporan Anda',
              style: TextStyle(fontSize: 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder:
                          (context) => const BottomNavigationWidget(
                            initialIndex: 1,
                            pages: [HomePage(), ReportScreen(), ProfilePage()],
                          ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    AppColor.primaryColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColor.primaryColor),
                    ),
                  ),
                ),
                child: const Text(
                  'Kembali ke Halaman Pertemuan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

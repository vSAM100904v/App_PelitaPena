import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/screens/appointment/appointment_screen.dart';

import '../../styles/color.dart';

class SuccessAppointment extends StatefulWidget {
  const SuccessAppointment({super.key});

  @override
  State<SuccessAppointment> createState() => _SuccessAppointmentState();
}

class _SuccessAppointmentState extends State<SuccessAppointment> {
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
              'Permintaan Pertemuan Terkirim',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Periksa notifikasi Anda secara berkala untuk melihat persetujuan permintaan janji temu.',
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
                      builder: (context) => const AppointmentPage(),
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

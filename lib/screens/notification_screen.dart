import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styles/color.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "NotifikasiIII",
            style: TextStyle(
              color: AppColor.descColor,
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Status Laporan",
                style: TextStyle(color: AppColor.primaryColor),
              ),
            ),
            Divider(height: 1, color: Colors.grey[400]),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 240,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Laporan DPMDPPA",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Kami ingin memberitahukan bahwa kami telah menerima dan  mengkonfirmasi laporan kasus yang Anda masukkan kepada Kantor Polisi Kabupaten toba. Kasus dengan nomor referensi 12AB370 telah ditinjau dan akan segera menjadi prioritas dalam penyelidikan kami.",
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "21-11-2023",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.primaryColor,
                      ),
                    ),
                    Row(
                      children: [
                        Text("03:45"),
                        Expanded(child: Container()),
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white,
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              AppColor.primaryColor,
                            ),
                            shape: MaterialStateProperty.all<
                              RoundedRectangleBorder
                            >(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(color: AppColor.primaryColor),
                              ),
                            ),
                          ),
                          onPressed: () {
                            print("Rincian");
                          },
                          child: Text(
                            "Lihat Rincian".toUpperCase(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

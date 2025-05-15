import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/atoms/placeholder_component.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/cards/appointment_card.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/appointment_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pa2_kelompok07/model/appointment_request_model.dart';
import 'package:pa2_kelompok07/screens/appointment/cancel_appointment_screen.dart';
import 'package:pa2_kelompok07/screens/appointment/form_appointment_screen.dart';

import '../../main.dart';
import '../../navigationBar/bottom_bar.dart';
import '../../provider/appointment_provider.dart';
import '../../provider/internet_provider.dart';
import '../../provider/user_provider.dart';
import '../../services/api_service.dart';
import '../../styles/color.dart';
import '../beranda_screen.dart';
import '../client/dpmdppa/report_screen.dart';
import '../profile/profile_screen.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppointmentProvider>(
      context,
      listen: false,
    ).fetchAppointments();
  }

  void _validateInput() {
    final text = _controller.text;
    int charCount = _countWords(text);
    bool isValid = charCount >= 8;
    _isButtonEnabled.value = isValid;
  }

  int _countWords(String text) {
    return text.replaceAll(' ', '').length;
  }

  void checkConnectionAndReload() {
    final internetProvider = Provider.of<InternetProvider>(
      context,
      listen: false,
    );
    if (internetProvider.hasInternet) {
      setState(() {
        APIService().fetchAppointments();
      });
    }
  }

  Widget buildReportSkeleton(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 10,
              top: 30,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 25,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 30,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
    final internetProvider = Provider.of<InternetProvider>(context);

    if (!internetProvider.hasInternet) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Permintaan Janji Temu",
            style: TextStyle(
              color: AppColor.descColor,
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColor.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) => const BottomNavigationWidget(
                        initialIndex: 2,
                        pages: [HomePage(), ReportScreen(), ProfilePage()],
                      ),
                ),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/no_wifi.png', width: 100),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Yah, internetnya mati",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Cek koneksi Wi-Fi atau kuota internetmu dan coba lagi, ya.",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkConnectionAndReload,
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
                      'Coba Lagi',
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
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Permintaan Pertemuan",
          style: TextStyle(
            color: AppColor.descColor,
            fontSize: 17,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(navigatorKey.currentState!.context)) {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) => const BottomNavigationWidget(
                        initialIndex: 2,
                        pages: [HomePage(), ReportScreen(), ProfilePage()],
                      ),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) => const BottomNavigationWidget(
                        initialIndex: 2,
                        pages: [HomePage(), ReportScreen(), ProfilePage()],
                      ),
                ),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/prosedur-janji-temu');
            },
            icon: const Icon(Icons.live_help_rounded, color: Colors.white),
          ),
        ],
      ),
      body: FutureBuilder<List<AppointmentRequestModel>>(
        future: APIService().fetchAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return buildReportSkeleton(context);
          } else if (snapshot.hasError) {
            return Center(
              child: PlaceHolderComponent(
                state: PlaceHolderState.error,
                errorCause: snapshot.error.toString(),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: PlaceHolderComponent(
                  state: PlaceHolderState.noScheduledMeetings,
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final appointment = snapshot.data![index];

                return AppointmentCard(
                  appointment: appointment,
                  onViewPressed: () {
                    showAppointmentDetailsDialog(context, appointment);
                  },
                  onEditPressed: () {
                    Navigator.of(context).pushNamed(
                      '/edit-janji-temu',
                      arguments: {'appointmentId': appointment.id},
                    );
                  },
                  onCancelPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CancelAppointmentScreen(
                              appointmentId: appointment.id,
                              waktuDimulai: appointment.waktuDimulai,
                              waktuSelesai: appointment.waktuSelesai,
                              details: appointment.keperluanKonsultasi,
                            ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: PlaceHolderComponent(
                state: PlaceHolderState.noScheduledMeetings,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.primaryColor,
        onPressed: () {
          if (userProvider.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormAppointmentScreen(),
              ),
            );
          } else {
            Navigator.of(
              context,
            ).pushNamed('/login', arguments: {'redirectTo': '/janji-temu'});
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

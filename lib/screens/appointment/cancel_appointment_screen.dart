import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/screens/appointment/appointment_screen.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';

import '../../styles/color.dart';

class CancelAppointmentScreen extends StatefulWidget {
  final int appointmentId;
  final String waktuDimulai;
  final String waktuSelesai;
  final String details;

  const CancelAppointmentScreen({
    Key? key,
    required this.appointmentId,
    required this.waktuDimulai,
    required this.waktuSelesai,
    required this.details,
  }) : super(key: key);

  @override
  State<CancelAppointmentScreen> createState() =>
      _CancelAppointmentScreenState();
}

class _CancelAppointmentScreenState extends State<CancelAppointmentScreen> {
  TextEditingController _cancelJanjiTemu = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  OverlayEntry? overlayEntry;

  void _validateInput() {
    final text = _cancelJanjiTemu.text;
    int charCount = _countWords(text);
    bool isValid = charCount >= 8;
    _isButtonEnabled.value = isValid;
  }

  int _countWords(String text) {
    return text.replaceAll(' ', '').length;
  }

  @override
  void initState() {
    super.initState();
    _cancelJanjiTemu.addListener(_validateInput);
  }

  @override
  void dispose() {
    _cancelJanjiTemu.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }

  Future<void> _handleCancel() async {
    showLoadingAnimated(context);
    try {
      await APIService().cancelAppointment(
        widget.appointmentId,
        _cancelJanjiTemu.text,
      );
      context.toast.showSuccess("Janji temu berhasil dibatalkan");
      // Fluttertoast.showToast(
      //   msg: "Janji temu berhasil dibatalkan",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
      closeLoadingDialog(context);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AppointmentPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      context.toast.showError("Janji temu gagal dibatalkan: $e");
      // Fluttertoast.showToast(
      //   msg: "Janji temu gagal dibatalkan",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pembatalan Janji Temu",
          style: TextStyle(
            color: AppColor.descColor,
            fontSize: 17,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Detail", style: TextStyle(fontSize: 12)),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  border: Border.all(color: Colors.black12, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  widget.details,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text("Alasan Pembatalan", style: TextStyle(fontSize: 12)),
              TextFormField(
                controller: _cancelJanjiTemu,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan alasan pembatalan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryColor,
                      textStyle: const TextStyle(fontSize: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_isButtonEnabled.value) _handleCancel();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColor.primaryColor,
                      textStyle: const TextStyle(fontSize: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text('Kirim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/screens/appointment/success_appointment.dart';

import '../../model/appointment_response_model.dart';
import '../../provider/user_provider.dart';
import '../../services/api_service.dart';
import '../../styles/color.dart';
import '../../utils/loading_dialog.dart';

class EditAppointmentScreen extends StatefulWidget {
  final int appointmentId;

  const EditAppointmentScreen({super.key, required this.appointmentId});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _purposeController = TextEditingController();

  DateTime? _waktuDimulai;
  DateTime? _waktuSelesai;
  final _keperluanKonsultasi = TextEditingController();

  Future<void> _selectDateStart(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _waktuDimulai ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_waktuDimulai ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _waktuDimulai = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectDateFinish(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _waktuSelesai ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_waktuSelesai ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _waktuSelesai = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ubah Janji Temu",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '*Ubah form jika ada kesalahan',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Text("Nama", style: TextStyle(fontSize: 12)),
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
                    '${userProvider.user?.full_name}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Nomor Telepon", style: TextStyle(fontSize: 12)),
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
                    '${userProvider.user?.phone_number}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    "Tanggal Dimulai: ${_waktuDimulai != null ? DateFormat('yyyy/MM/dd').format(_waktuDimulai!) : 'Pilih tanggal'}",
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDateStart(context);
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    "Tanggal Selesai: ${_waktuSelesai != null ? DateFormat('yyyy/MM/dd').format(_waktuSelesai!) : 'Pilih tanggal'}",
                  ),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () {
                    _selectDateFinish(context);
                  },
                ),
                const SizedBox(height: 16),
                const Text("Keperluan Temu", style: TextStyle(fontSize: 12)),
                TextFormField(
                  controller: _keperluanKonsultasi,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harap masukkan keperluan temu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                      child: const Text('Batal'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: editAppointment,
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
      ),
    );
  }

  Future<void> editAppointment() async {
    if (!_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Harap isi semua data yang diperlukan."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return;
    }

    showLoadingAnimated(context);

    DateTime waktuMulai = _waktuDimulai ?? DateTime.now();
    DateTime waktuSelesai = _waktuSelesai ?? DateTime.now();
    String keperluanKonsultasi = _keperluanKonsultasi.text;
    print("Apoointment ID ${widget.appointmentId}");
    try {
      await APIService().editAppointment(
        widget.appointmentId,
        waktuMulai,
        waktuSelesai,
        keperluanKonsultasi,
      );

      Navigator.of(context).pop();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SuccessAppointment()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      closeLoadingDialog(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Gagal membuat janji temu: $e"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }
}

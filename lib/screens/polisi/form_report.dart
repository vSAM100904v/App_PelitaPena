import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../provider/user_provider.dart';
import '../../services/api_service.dart';

class FormReportPolice extends StatefulWidget {
  const FormReportPolice({Key? key}) : super(key: key);

  @override
  State<FormReportPolice> createState() => _FormReportPoliceState();
}

class _FormReportPoliceState extends State<FormReportPolice> {
  int currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  File? _image;

  Future<void> getImagePicker() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    setState(() {
      _image = File(image.path);
    });
  }

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  DateTime? selectedDate;
  String? selectedLocation;
  String? visibility = "anonim";
  String? _tanggalError;
  String? document;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buat Laporan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColor.descColor,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.descColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Container();
        },
      ),
    );
  }

  List<Step> getSteps() => [
    Step(
      title: const Text('Tulis Laporan'),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColor.primaryColor),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Prosedur atau cara menyampaikan pengaduan yang baik dan benar",
                    style: TextStyle(
                      // Apply your text styles here
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 10),
            const Text("Judul", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ketik judul laporan anda',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const Text("Isi", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            TextFormField(
              controller: _isiController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ketik isi laporan anda',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isi tidak boleh kosong';
                }
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.calendar_today, size: 20),
              title: Text(
                selectedDate == null
                    ? 'Pilih Tanggal Kejadian'
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
              onTap: _pickDate,
            ),
            if (_tanggalError != null)
              Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Text(
                  _tanggalError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 10),
            ListTile(
              title: Text(selectedLocation ?? 'Pilih Lokasi Kejadian'),
              leading: const Icon(Icons.map, size: 20),
              onTap: () {
                // Implement location picker logic
              },
            ),
            IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      selectedLocation == null
                          ? 'Lokasi masih kosong'
                          : 'Jl. Sitoluama, Laguboti, Toba Samosir, Sumatera Utara',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            visibility == "anonim"
                                ? AppColor.primaryColor
                                : Colors.grey,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: "anonim",
                          groupValue: visibility,
                          onChanged: (value) {
                            setState(() {
                              visibility = value;
                              print(visibility);
                            });
                          },
                        ),
                        const Text('Anonim'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            visibility == "publik"
                                ? AppColor.primaryColor
                                : Colors.grey,
                      ), // Menyesuaikan warna border saat dipilih atau tidak
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                          value: "publik",
                          groupValue: visibility,
                          onChanged: (value) {
                            setState(() {
                              visibility = value;
                            });
                          },
                        ),
                        const Text('Publik'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.grey, thickness: 1),
            SizedBox(
              height: 100,
              width: 100,
              child: _image != null ? Image.file(_image!) : Container(),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    getImagePicker();
                  },
                  icon: Icon(Icons.image, color: AppColor.primaryColor),
                  iconSize: 30,
                  splashColor: AppColor.primaryColor,
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.upload_file, color: AppColor.primaryColor),
                  iconSize: 30,
                  splashColor: AppColor.primaryColor,
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: _onStepContinue,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text('Lanjutkan'),
                ),
              ],
            ),
          ],
        ),
      ),
      state: stepState(0),
      isActive: currentStep >= 0,
    ),
    Step(
      title: const Text('Tinjau'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColor.primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(text: 'Laporan ini bersifat '),
                      TextSpan(
                        text: visibility == 1 ? 'Anonim' : 'Publik',
                        style: TextStyle(
                          color:
                              visibility == 1
                                  ? AppColor.primaryColor
                                  : AppColor
                                      .primaryColor, // Warna khusus untuk "Anonim" atau "Publik"
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 10),
          const Text("Judul", style: TextStyle(fontSize: 16)),
          Text(_judulController.text, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            "Tanggal Kejadian: ${selectedDate != null ? DateFormat('EEEE, dd MMMM yyyy').format(selectedDate!) : 'Tanggal belum dipilih'}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Icon(Icons.location_on_outlined),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lokasi", style: TextStyle(fontSize: 16)),
                  Text("Kabupaten Toba", style: TextStyle(fontSize: 16)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Lampiran", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: _image != null ? Image.file(_image!) : Container(),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _onStepCancel,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text('Kembali'),
                ),
                Expanded(child: Container()),
                ElevatedButton(
                  onPressed: () {
                    submitReport();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColor.primaryColor,
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
          ),
        ],
      ),
      state: stepState(1),
      isActive: currentStep >= 1,
    ),
  ];

  StepState stepState(int step) {
    if (currentStep > step) {
      return StepState.complete;
    } else if (currentStep == step) {
      return StepState.indexed;
    } else {
      return StepState.indexed;
    }
  }

  void _onStepContinue() {
    bool isFormValid = _formKey.currentState!.validate();

    if (selectedDate == null) {
      setState(() {
        _tanggalError = 'Tanggal kejadian harus dipilih';
      });
      isFormValid = false;
    } else {
      setState(() {
        _tanggalError = null;
      });
    }

    if (isFormValid && currentStep < (getSteps().length - 1)) {
      setState(() {
        currentStep += 1;
      });
    }
  }

  void _onStepCancel() {
    if (currentStep > 0) {
      setState(() {
        currentStep -= 1;
      });
    }
  }

  void _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null && date != selectedDate) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> submitReport() async {
    int? userIdS = Provider.of<UserProvider>(context, listen: false).userId;
    if (_formKey.currentState!.validate()) {
      int? userId = userIdS;
      String judul = _judulController.text;
      String isi = _isiController.text;
      String tanggal = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String lokasi = _isiController.text;
      String visibilityString = visibility.toString();
      String? token = await _storage.read(key: 'userToken');
      print("Submitting report...");
      print(token);

      final response = await http.post(
        Uri.parse('${Config.apiUrl}${Config.postFormAPIPolice}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'judul_pelaporan': judul,
          'visibility': visibilityString,
          'isi_laporan': isi,
          'tanggal_kejadian': tanggal,
          'lokasi_kejadian': lokasi,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Data has been created");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laporan berhasil dibuat!')),
        );

        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
        });
      } else {
        print(
          'Error: Server responded with status code: ${response.statusCode}',
        );
        print('Response body: ${response.body}');
        throw Exception('Failed to create pelaporan');
      }
    }
  }
}

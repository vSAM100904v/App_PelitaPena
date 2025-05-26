import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/model/appointment_response_model.dart';
import 'package:pa2_kelompok07/screens/appointment/success_appointment.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import '../../provider/user_provider.dart';
import '../../styles/color.dart';

class FormAppointmentScreen extends StatefulWidget {
  const FormAppointmentScreen({super.key});

  @override
  State<FormAppointmentScreen> createState() => _FormAppointmentScreenState();
}

class _FormAppointmentScreenState extends State<FormAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _waktuDimulai;
  DateTime? _waktuSelesai;
  final _keperluanKonsultasi = TextEditingController();

  /// Daftar hari libur (format: yyyy-MM-dd)
  final List<DateTime> _holidays = [
    DateTime(2025, 1, 1), // Tahun Baru
    DateTime(2025, 5, 1), // Hari Buruh
    DateTime(2025, 12, 25), // Natal
    // Tambahkan tanggal libur lainnya di sini
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStartDate
              ? _waktuDimulai ?? DateTime.now()
              : _waktuSelesai ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      selectableDayPredicate: (date) {
        // Hanya Senin (1) sampai Jumat (5)
        if (date.weekday < DateTime.monday || date.weekday > DateTime.friday) {
          return false;
        }
        // Cek hari libur
        for (final d in _holidays) {
          if (d.year == date.year &&
              d.month == date.month &&
              d.day == date.day) {
            return false;
          }
        }
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isStartDate
              ? _waktuDimulai ?? DateTime.now()
              : _waktuSelesai ?? DateTime.now(),
        ),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColor.primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primaryColor,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Validasi jam: hanya 08:00 - 17:00
        if (pickedTime.hour < 8 || pickedTime.hour > 17) {
          _showErrorDialog('Pilih waktu antara 08:00 dan 17:00.');
          return;
        }

        setState(() {
          final dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (isStartDate) {
            _waktuDimulai = dateTime;
            if (_waktuSelesai == null || _waktuSelesai!.isBefore(dateTime)) {
              _waktuSelesai = dateTime.add(const Duration(hours: 1));
            }
          } else {
            _waktuSelesai = dateTime;
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _keperluanKonsultasi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Formulir Permintaan",
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '*Wajib mengisi semua form dengan data yang benar',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 24),

              // User Info Section
              Text(
                "Informasi Pemohon",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoCard(
                context,
                title: "Nama",
                value: userProvider.user?.full_name ?? '-',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context,
                title: "Nomor Telepon",
                value: userProvider.user?.phone_number ?? '-',
              ),
              const SizedBox(height: 24),

              // Appointment Time Section
              Text(
                "Waktu Janji Temu",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              _buildDateTimePicker(
                context,
                label: "Mulai",
                dateTime: _waktuDimulai,
                onTap: () => _selectDate(context, true),
              ),
              const SizedBox(height: 12),
              _buildDateTimePicker(
                context,
                label: "Selesai",
                dateTime: _waktuSelesai,
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 24),

              // Purpose Section
              Text(
                "Tujuan Janji Temu",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _keperluanKonsultasi,
                decoration: InputDecoration(
                  hintText: "Masukkan tujuan janji temu...",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black54),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColor.primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan tujuan temu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black54),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: createAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Kirim'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color.fromARGB(255, 136, 136, 136),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black54),
          ),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromARGB(255, 124, 121, 121),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(
    BuildContext context, {
    required String label,
    required DateTime? dateTime,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color.fromARGB(255, 123, 122, 122),
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(137, 104, 103, 103),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateTime != null
                      // Di sini kita pakai hh:mm a untuk 12-hour clock + AM/PM
                      ? DateFormat('dd MMM yyyy, hh:mm a').format(dateTime)
                      : 'Pilih tanggal & waktu',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        dateTime != null
                            ? const Color.fromARGB(255, 107, 105, 105)
                            : const Color.fromARGB(
                              255,
                              131,
                              130,
                              130,
                            ).withOpacity(0.5),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColor.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> createAppointment() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorDialog("Harap isi semua data yang diperlukan.");
      return;
    }

    if (_waktuDimulai == null || _waktuSelesai == null) {
      _showErrorDialog("Harap pilih waktu mulai dan selesai.");
      return;
    }

    // Validasi hari dan jam
    final start = _waktuDimulai!;
    final end = _waktuSelesai!;

    if (start.weekday < DateTime.monday ||
        start.weekday > DateTime.friday ||
        end.weekday < DateTime.monday ||
        end.weekday > DateTime.friday) {
      _showErrorDialog(
        "Janji temu hanya dapat dibuat pada hari Senin hingga Jumat.",
      );
      return;
    }

    for (final d in _holidays) {
      if ((d.year == start.year &&
              d.month == start.month &&
              d.day == start.day) ||
          (d.year == end.year && d.month == end.month && d.day == end.day)) {
        _showErrorDialog("Janji temu tidak dapat dibuat pada hari libur.");
        return;
      }
    }

    if (start.hour < 8 || end.hour > 17) {
      _showErrorDialog("Jam janji temu harus antara 08:00 dan 17:00.");
      return;
    }

    if (end.isBefore(start)) {
      _showErrorDialog("Waktu selesai tidak boleh sebelum waktu mulai.");
      return;
    }

    showLoadingAnimated(context);

    try {
      final response = await APIService().submitAppointment(
        start,
        end,
        _keperluanKonsultasi.text,
      );

      Navigator.of(context).pop();

      if (response.code == 201) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SuccessAppointment()),
          (Route<dynamic> route) => false,
        );
      } else {
        throw Exception(
          'Gagal mengirim janji temu: ${response.message ?? "Unknown error"}',
        );
      }
    } catch (e) {
      closeLoadingDialog(context);
      _showErrorDialog("Gagal membuat janji temu: ${e.toString()}");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              "Error",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.redAccent),
            ),
            content: Text(message, style: const TextStyle(color: Colors.black)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
    );
  }
}

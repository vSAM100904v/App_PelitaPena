import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/model/auth/login_request_model.dart';
import 'package:pa2_kelompok07/services/api_service.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';

import '../../model/auth/register_response_model.dart';
import '../../provider/user_provider.dart';
import '../../styles/color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool isApiCallProcess = false;

  final Color primaryGreen = const Color(0xFF7FBC8C);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (isApiCallProcess)
            const Center(child: CircularProgressIndicator()),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.people_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap:
                              () => Navigator.of(context).pushNamed('/login'),
                          child: Text(
                            'Masuk',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Nama Lengkap
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nama Lengkap",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fullNameController,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan nama lengkap",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[600],
                        ),
                        errorMaxLines: 2,
                      ),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? 'Silakan masukkan nama lengkap'
                                  : null,
                    ),
                    const SizedBox(height: 20),

                    // Alamat Email
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Alamat Email",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan email anda",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey[600],
                        ),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Silakan masukkan email';
                        final emailRegex = RegExp(
                          r'^[A-Za-z0-9._%+-]+@[^@]+\.[^@]+',
                        );
                        if (!emailRegex.hasMatch(value))
                          return 'Format email tidak valid';
                        if (!value.toLowerCase().endsWith('@gmail.com'))
                          return 'Email harus berakhiran @gmail.com';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Nomor HP
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nomor HP",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _noHpController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan nomor HP anda",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.phone_android_outlined,
                          color: Colors.grey[600],
                        ),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Silakan masukkan no hp';
                        final phoneRegex = RegExp(r'^08\d{9,11}$');
                        if (!phoneRegex.hasMatch(value))
                          return 'Format nomor telepon tidak valid. Harus diawali 08 dan panjang 11-13 digit.';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Kata Sandi
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Masukkan kata sandi",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed:
                              () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                        ),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Silakan masukkan password';
                        final pw = value;
                        final missing = <String>[];
                        if (pw.length < 8) missing.add('Minimal 8 karakter');
                        if (!RegExp(r'[A-Z]').hasMatch(pw))
                          missing.add('Satu huruf besar');
                        if (!RegExp(r'[a-z]').hasMatch(pw))
                          missing.add('Satu huruf kecil');
                        if (!RegExp(r'\d').hasMatch(pw))
                          missing.add('Satu angka');
                        if (!RegExp(r'[^A-Za-z0-9]').hasMatch(pw))
                          missing.add('Satu simbol unik');
                        if (missing.isNotEmpty)
                          return 'Password harus: ${missing.join(', ')}';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Konfirmasi Kata Sandi
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Konfirmasi Kata Sandi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(
                        color: Color(0xFF393939),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Konfirmasi kata sandi anda",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed:
                              () => setState(
                                () =>
                                    _isConfirmPasswordVisible =
                                        !_isConfirmPasswordVisible,
                              ),
                        ),
                        errorMaxLines: 2,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Silakan masukkan konfirmasi password';
                        if (value != _passwordController.text)
                          return 'Konfirmasi tidak sesuai dengan password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: submitRegister,
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            primaryGreen,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: primaryGreen),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    return _formKey.currentState?.validate() ?? false;
  }

  Future<void> submitRegister() async {
    if (!validateAndSave()) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Error"),
              content: const Text("Harap isi semua data yang diperlukan."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    showLoadingAnimated(context);

    final fullName = _fullNameController.text;
    final noHp = _noHpController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final user = await APIService().register(
        email,
        password,
        fullName,
        noHp,
        await NotificationService.instance.getStoredFcmToken() ?? "empty_token",
      );

      closeLoadingDialog(context);

      if (user.success == 200) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        throw Exception('Server respon: ${user.success}');
      }
    } catch (e) {
      closeLoadingDialog(context);
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text("Error"),
              content: Text("Gagal melakukan registrasi: $e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
    }
  }
}

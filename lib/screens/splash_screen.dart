import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/beranda/admin_dashboard.dart';
import 'package:pa2_kelompok07/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/navigationBar/bottom_bar.dart';
import 'package:pa2_kelompok07/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initRedirect();
  }

  Future<void> _initRedirect() async {
    // Delay supaya logo sempat tampil beberapa detik
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Cek status login dari UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAuthenticated = userProvider.isLoggedIn;

    if (!isAuthenticated) {
      // Kalau belum login, selalu langsung ke Onboarding
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    // Kalau sudah login, cek role dan arahkan
    final userRole = userProvider.user?.role;
    if (userRole == "admin") {
      Navigator.of(context).pushReplacementNamed('/admin-layout');
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const BottomNavigationWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/Logo.png'),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

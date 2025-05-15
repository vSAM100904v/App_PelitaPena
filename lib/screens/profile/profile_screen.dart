import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/screens/client/chat/rooms_client_screen.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/maintanance.dart';
import 'package:pa2_kelompok07/screens/auth/login_screen.dart';
import 'package:pa2_kelompok07/screens/auth/register_screen.dart';
import 'package:pa2_kelompok07/screens/profile/edit_profile_screen.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../provider/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ShowDialogMaintanance _showDialogMaintanance = ShowDialogMaintanance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isLoggedIn && userProvider.user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Halaman Profil",
            style: TextStyle(
              color: AppColor.descColor,
              fontSize: 17,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColor.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                userProvider.user?.photo_profile != "" ||
                                        auth
                                                .FirebaseAuth
                                                .instance
                                                .currentUser
                                                ?.photoURL !=
                                            null
                                    ? CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundImage: NetworkImage(
                                          userProvider.user?.photo_profile ??
                                              auth
                                                  .FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .photoURL!,
                                        ),
                                      ),
                                    )
                                    : const CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person, size: 35),
                                    ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userProvider.user?.full_name}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '@${userProvider.user?.username}',
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(child: Container()),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Email : ${userProvider.user?.email}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "No.Telp : ${userProvider.user?.phone_number}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 1. edit profil
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/edit-profile');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Edit Akun',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2. riwayat Laporan--
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/edit-password');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_outline, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Edit Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 2. riwayat Laporan--
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/laporan');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.history, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Riwayat Laporan Anda',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Janji Temu
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/janji-temu');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/appointment.png'),
                            const SizedBox(width: 10),
                            const Text(
                              'Request Pertemuan',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (userProvider.userId != null) ...[
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          ScreenNavigator(cx: context).navigate(
                            ClientChatPageSelf(
                              userId:
                                  userProvider.user?.id.toString() ?? "admin",
                              userRole: "client",
                              currentUserName:
                                  userProvider.user?.full_name ?? "Client",
                              userToken: userProvider.userToken,
                            ),
                            NavigatorTweens.rightToLeft(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.sizeOf(context).width,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.support_agent, color: Colors.black),
                              SizedBox(width: 10),
                              Text(
                                'Bantuan',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        userProvider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.logout, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Keluar',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 120,
                decoration: BoxDecoration(color: AppColor.primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                child: Column(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Halo👋,silahkan login terlebih dahulu ya!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.person, size: 35),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed:
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const RegisterPage(),
                                        ),
                                      ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: AppColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Daftar"),
                                ),
                                const SizedBox(width: 5),
                                OutlinedButton(
                                  onPressed:
                                      () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(),
                                        ),
                                      ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (userProvider.isLoggedIn) {
                          Navigator.of(context).pushNamed('/laporan');
                        } else {
                          Navigator.of(context).pushNamed(
                            '/login',
                            arguments: {'redirectTo': '/laporan'},
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.note_outlined, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Laporan Anda',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (userProvider.isLoggedIn) {
                          Navigator.of(context).pushNamed('/janji-temu');
                        } else {
                          Navigator.of(context).pushNamed(
                            '/login',
                            arguments: {'redirectTo': '/janji-temu'},
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/appointment.png'),
                            const SizedBox(width: 10),
                            const Text(
                              'Request Pertemuan',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        _showDialogMaintanance.showMyDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.question_mark, color: Colors.black),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Syarat & Ketentuan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Baca syarat & ketentuan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
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
            ],
          ),
        ),
      );
    }
  }
}

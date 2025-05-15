import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/toasters/toast.dart';
import 'package:pa2_kelompok07/core/persentation/widgets/dialogs/logout_dialog.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../pages/beranda/admin_dashboard.dart';
import '../pages/Donasi/donasi.dart';
import '../pages/event/event.dart';
import '../pages/konten/konten.dart';

class AppSidebar extends StatefulWidget {
  const AppSidebar({Key? key}) : super(key: key);

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Beranda.primaryBlue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-4BrnI3yirocxVzGB1nmUAEB8IOBarm.png',
                  ),
                  radius: 30,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Admin PendikaApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'admin@pendika.org',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home,
            title: 'Beranda',
            isActive: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Beranda()),
              );
            },
          ),

          _buildMenuItem(
            context,
            icon: Icons.article,
            title: 'Konten',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Konten()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.event,
            title: 'Event',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Event()),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.volunteer_activism,
            title: 'Donasi',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Donasi()),
              );
            },
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Chat',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Membuka Chat')));
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.warning_amber_outlined,
            title: 'Peringatan',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka Peringatan')),
              );
            },
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: 'Pengaturan',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuka Pengaturan')),
              );
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.help_outline,
            title: 'Bantuan',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Membuka Bantuan')));
            },
          ),
          _buildMenuItem(
            context,
            icon: Icons.logout,
            title: 'Keluar',
            onTap:
                () => _handleLogout(
                  context,
                  _userProvider.user?.full_name ?? "admin",
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Beranda.primaryBlue : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? Beranda.primaryBlue : Colors.grey[800],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isActive ? const Color(0xFFEAF2F8) : null,
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => LogoutConfirmationDialog(
            userName: userName,
            onLogoutConfirmed: () async {
              try {
                await _userProvider.logout();
                // Periksa apakah widget masih mounted sebelum navigasi
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                } else {
                  // TODO:
                }
              } catch (e) {
                if (mounted) {
                  // Tampilkan pesan error jika masih mounted
                  context.toast.showError("Logout Gagal");
                }
              }
            },
          ),
    );
  }
}

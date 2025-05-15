import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pa2_kelompok07/styles/color.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/screen_navigator.dart';
import 'package:pa2_kelompok07/provider/user_provider.dart';

// import halaman-halaman yang sudah ada
import '../screens/beranda_screen.dart';
import '../screens/client/dpmdppa/report_screen.dart';
import '../screens/appointment/appointment_screen.dart';

// import widget chat
import '../screens/client/chat/rooms_client_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int initialIndex;
  final List<Widget> pages;

  const BottomNavigationWidget({
    Key? key,
    this.initialIndex = 0,
    this.pages = const <Widget>[
      HomePage(),
      ReportScreen(),
      SizedBox(), // placeholder untuk Chat
      AppointmentPage(),
    ],
  }) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigasi ke chat dengan ClientChatPageSelf
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        ScreenNavigator(cx: context).navigate(
          ClientChatPageSelf(
            userId: user.id.toString(),
            userRole: 'client',
            userToken: userProvider.userToken,
            currentUserName: user.full_name,
          ),
          NavigatorTweens.rightToLeft(),
        );
      } else {
        // Jika belum login, mungkin arahkan ke login atau tampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan login terlebih dahulu')),
        );
      }
      return;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: widget.pages.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColor.primaryColor,
            unselectedItemColor: AppColor.darkGreen,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            iconSize: 28,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home_rounded),
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.description_outlined),
                ),
                label: 'Laporkan',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.chat_bubble_outline),
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.calendar_today_outlined),
                ),
                label: 'Janji Temu',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}

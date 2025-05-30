import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import 'package:pa2_kelompok07/config.dart';
import 'package:pa2_kelompok07/core/constant/constant.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';

import 'package:pa2_kelompok07/provider/user_provider.dart';
import 'package:pa2_kelompok07/screens/admin/pages/chat/chat_admin_screen.dart';
import 'package:pa2_kelompok07/screens/admin/pages/dashboard/dashboard_admin_page.dart';
import 'package:pa2_kelompok07/screens/admin/pages/dashboard_page/reports_page.dart.dart';
import 'package:pa2_kelompok07/screens/admin/widgets/sidebar.dart';
import 'package:provider/provider.dart';

class AdminLayout extends StatefulWidget {
  const AdminLayout({super.key});

  final String title = "Admin PelitaPena";

  @override
  _AdminLayoutState createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout>
    with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  late final UserProvider _userProvider;
  late final ValueNotifier<int> _selectedTabNotifier;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _motionTabBarController = MotionTabBarController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );
    _selectedTabNotifier = ValueNotifier<int>(_motionTabBarController!.index);
  }

  @override
  void dispose() {
    _motionTabBarController?.dispose();
    _selectedTabNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ResponsiveSizes rs = context.responsive;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: ValueListenableBuilder<int>(
          valueListenable: _selectedTabNotifier,
          builder: (context, selectedTab, _) {
            String title;
            switch (selectedTab) {
              case 0:
                title = "Laporan";
                break;
              case 1:
                title = "Dashboard";
                break;
              case 2:
                title = "Chat";
                break;
              default:
                title = "Unknown";
            }
            return Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          },
        ),
        actions: [
          Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              final user = userProvider.user;
              final String? imageUrl = user?.photo_profile;
              return Padding(
                padding: EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      backgroundImage: CachedNetworkImageProvider(
                        imageUrl ?? Config.fallbackImage,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: Color(0xFF7CB9E8),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        toolbarHeight: 56,
      ),
      drawer: AppSidebar(),
      backgroundColor: AppColors.white,
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController,
        initialSelectedTab: "Home",
        useSafeArea: true,
        labelAlwaysVisible: false,
        labels: const ["Laporan", "Home", "Chat"],
        icons: const [Icons.summarize, Icons.home, Icons.chat_rounded],
        tabSize: rs.space(SizeScale.xxxl) + rs.space(SizeScale.xl),
        tabBarHeight: rs.space(SizeScale.xxxl) + rs.space(SizeScale.xl),
        textStyle: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        tabIconSize: rs.space(SizeScale.xxxl) + 2,
        tabIconSelectedSize: rs.space(SizeScale.xxxl) + 2,
        tabSelectedColor: Colors.white,
        tabIconSelectedColor: Colors.black,
        tabBarColor: AppColors.white,
        onTabItemSelected: (int value) {
          _motionTabBarController!.index = value;
          _selectedTabNotifier.value = value;
        },
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedTabNotifier,
        builder: (context, selectedIndex, _) {
          return TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _motionTabBarController,
            children: <Widget>[
              DashboardViewReportPage(),
              DashboardRootPage(controller: _motionTabBarController!),
              AdminChatListScreen(),
            ],
          );
        },
      ),
    );
  }
}

class MainPageContentComponent extends StatelessWidget {
  const MainPageContentComponent({
    required this.title,
    required this.controller,
    super.key,
  });

  final String title;
  final MotionTabBarController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Go to "X" page programmatically'),
          ElevatedButton(
            onPressed: () => controller.index = 0,
            child: const Text('Dashboard Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 1,
            child: const Text('Home Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 2,
            child: const Text('Profile Page'),
          ),
          ElevatedButton(
            onPressed: () => controller.index = 3,
            child: const Text('Settings Page'),
          ),
        ],
      ),
    );
  }
}

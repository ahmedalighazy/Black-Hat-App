
import 'package:black_hat_app/controller/bloc.dart';
import 'package:black_hat_app/controller/cashe/cashe_Helper.dart';
import 'package:black_hat_app/controller/dio/dio_helper.dart';
import 'package:black_hat_app/core/helper/fake_data.dart';
import 'package:black_hat_app/core/theme/app_theme.dart';
import 'package:black_hat_app/ui/create_post_screen/new_post_screen.dart';
import 'package:black_hat_app/ui/home_screen/widgets/app_bar.dart';
import 'package:black_hat_app/ui/home_screen/widgets/bottom_navigationbar.dart';
import 'package:black_hat_app/ui/notification_screen/notifications_screen.dart';
import 'package:black_hat_app/ui/profile_screen/profile_screen.dart';
import 'package:black_hat_app/ui/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'ui/home_screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Black Hat',
          theme: appTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  void _handleLike(int index) {
    setState(() {
      FakeData.isLiked[index] = !FakeData.isLiked[index];
      FakeData.likes[index] += FakeData.isLiked[index] ? 1 : -1;
    });
  }

  final List<IconData> _navIcons = const [
    Icons.home,
    Icons.search,
    Icons.add,
    Icons.notifications,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        setState: (showSearch) {
          setState(() {
            _showSearch = !showSearch;
          });
        },
        searchController: _searchController,
        showSearch: _showSearch,
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: bottomNavigationBar(
        selectedIndex: _selectedIndex,
        navIcons: _navIcons,
        setState: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _getCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return buildHomeScreen(_handleLike);
      case 1:
        return buildSearchScreen();
      case 2:
        return buildNewPostScreen();
      case 3:
        return buildNotificationsScreen();
      case 4:
        return buildProfileScreen();
      default:
        return buildHomeScreen(_handleLike);
    }
  }
}

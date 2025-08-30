import 'package:bookshop/providers/user_provider.dart';
import 'package:bookshop/screens/auth_screen.dart';
import 'package:bookshop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookshop/screens/home_screen.dart';
import 'package:bookshop/screens/shopping_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _screenIndex = 0;
  int _navIndex = 0;
  bool _showMiniMenu = false;
  int _previousScreenIndex = 0;

  void _onItemTapped(int index) {
    if (index == 3) {
      setState(() {
        if (!_showMiniMenu) {
          _previousScreenIndex = _screenIndex;
          _showMiniMenu = true;
          _navIndex = 3;
        } else {
          _showMiniMenu = false;
          _screenIndex = _previousScreenIndex;
          _navIndex = _previousScreenIndex;
        }
      });
    } else {
      setState(() {
        _screenIndex = index;
        _navIndex = index;
        _showMiniMenu = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final bool isLoggedIn = user != null;

    final List<Widget> screens = [
      const HomeScreenContent(),
      const ShoppingScreenContent(),
      isLoggedIn
          ? ProfileScreen(userName: user.name, userEmail: user.email)
          : const AuthScreenContent(),
    ];

    final List<Widget> navItems = [
      Icon(Icons.home_outlined,
          color: (_navIndex == 0) ? const Color(0xFFFAF8F6) : const Color(0xFF382110)),
      Icon(Icons.shopping_cart_outlined,
          color: (_navIndex == 1) ? const Color(0xFFFAF8F6) : const Color(0xFF382110)),
      Icon(Icons.person_outline,
          color: (_navIndex == 2) ? const Color(0xFFFAF8F6) : const Color(0xFF382110)),
      Icon(Icons.menu_outlined,
          color: (_navIndex == 3) ? const Color(0xFFFAF8F6) : const Color(0xFF382110)),
    ];

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_showMiniMenu) {
            setState(() {
              _showMiniMenu = false;
              _screenIndex = _previousScreenIndex;
              _navIndex = _previousScreenIndex;
            });
          }
        },
        child: Stack(
          children: [
            IndexedStack(
              index: _screenIndex,
              children: screens,
            ),
            if (_showMiniMenu)
              Positioned(
                bottom: 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {}, // Evita que cerrar el menu al tocarlo
                  child: Container(
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: const [
                        ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Settings'),
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('About'),
                        ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _navIndex,
        height: 50,
        backgroundColor: const Color(0xFFFAF8F6),
        color: Color.fromRGBO(235, 226, 215, 1.0),
        buttonBackgroundColor: Color(0xFF382110),
        animationDuration: const Duration(milliseconds: 300),
        onTap: _onItemTapped,
        items: navItems,
      ),
    );
  }
}
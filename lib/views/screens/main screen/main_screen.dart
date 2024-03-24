import "package:easyshop/views/screens/HomeScreen/home_screen.dart";
import "package:easyshop/views/screens/bookmark/bookmark_screen.dart";
import "package:easyshop/views/screens/cart/cart_screen.dart";
import "package:easyshop/views/screens/profile/profile_screen.dart";
import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final double iconSize = 30.0;
  int _selectIndex = 0;

  // List of screen
  final List<Widget> _pages = [
    const HomePage(),
    const BookMarkScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.white;
    return Scaffold(
      body: _pages[_selectIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 70.0,
        buttonBackgroundColor: const Color(0xFF8A9418),
        backgroundColor: Colors.transparent,
        color: const Color(0xFF0C2D57),
        items: <Widget>[
          Icon(
            Icons.home,
            size: iconSize,
            color: iconColor,
          ),
          Icon(Icons.bookmark, size: iconSize, color: iconColor),
          Icon(Icons.shopping_cart, size: iconSize, color: iconColor),
          Icon(Icons.person, size: iconSize, color: iconColor),
        ],
        onTap: (index) => {
          setState(() {
            _selectIndex = index;
          })
        },
        // Index of the currently selected item.
        index: _selectIndex,
      ),
    );
  }
}

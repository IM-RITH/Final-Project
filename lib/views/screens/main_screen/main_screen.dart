import 'package:easyshop/provider/cart_provider.dart';
import 'package:easyshop/provider/favorite_provider.dart';
import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:provider/provider.dart';
// import 'package:badges/badges.dart' as badges;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final double iconSize = 30.0;
  int _selectedIndex = 0;

  // List of screen
  final List<Widget> _pages = [
    const HomePage(),
    const BookMarkScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    int cartCount = ref.watch(cartProvider.select((map) => map.length));
    bool hasViewedCart = ref.watch(cartProvider.notifier).hasViewedCart;
    int favoriteCount = ref.watch(favoriteProvider.select((map) => map.length));
    bool hasViewFavorite =
        ref.watch(favoriteProvider.notifier).hasViewedFavorite;
    Color iconColor = Colors.white;

    return SafeArea(
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 55.0,
          buttonBackgroundColor: const Color(0xFF8A9418),
          backgroundColor: Colors.transparent,
          color: const Color(0xFF0C2D57),
          items: <Widget>[
            Icon(Icons.home, size: iconSize, color: iconColor),
            // favorite screen
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.bookmark, size: iconSize, color: iconColor),
                if (favoriteCount > 0 && !hasViewFavorite)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$favoriteCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Icon(Icons.shopping_cart, size: iconSize, color: iconColor),
                if (cartCount > 0 && !hasViewedCart)
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            Icon(Icons.person, size: iconSize, color: iconColor),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              if (index == 1) {
                // Assuming favorite Screen is at index 1
                ref.read(favoriteProvider.notifier).setViewedFavorite(true);
              }
              if (index == 2) {
                // Assuming CartScreen is at index 2
                ref.read(cartProvider.notifier).setViewedCart(true);
              }
            });
          },
        ),
      ),
    );
  }
}

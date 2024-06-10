import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/controller/auth_controller.dart';
import 'package:easyshop/views/screens/auth/login_screen.dart';
import 'package:easyshop/views/screens/bookmark/bookmark_screen.dart';
import 'package:easyshop/views/screens/profile/edit_profile.dart';
import 'package:easyshop/views/screens/profile/my_order.dart';
import 'package:easyshop/views/screens/profile/order_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthController _authController = AuthController();
  Future<DocumentSnapshot?>? _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUserData();
  }

  Future<DocumentSnapshot?> _fetchUserData() async {
    CollectionReference buyers =
        FirebaseFirestore.instance.collection('buyers');
    return await buyers.doc(_auth.currentUser!.uid).get();
  }

  Future<void> _refreshContent() async {
    setState(() {
      _userFuture = _fetchUserData();
    });
    await _userFuture;
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Icon(
                Icons.logout,
                size: 50,
                color: Colors.red,
              ),
              const SizedBox(height: 10),
              Text(
                'Confirm Logout',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.poppins(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );
                  await Future.delayed(
                    const Duration(seconds: 2),
                  );
                  await _authController.signOut();
                  Get.back();
                  Get.offAll(() => const LoginScreen());
                },
                child: Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot?>(
      future: _userFuture,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot?> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) {
            return const Text("No data found");
          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: RefreshIndicator(
              onRefresh: _refreshContent,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Background with gradient and blur
                        Container(
                          height: 190,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF1F2544), Color(0xFF1F2544)],
                            ),
                          ),
                        ),
                        // Profile Image
                        Positioned(
                          top: 100,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(75),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                data['profileImage'],
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    FontAwesomeIcons.user,
                                    size: 150,
                                    color: Colors.grey[300],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),
                    Text(
                      data['username'],
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF102C57),
                      ),
                    ),
                    Text(
                      data['email'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Profile Menu Items
                    ProfileMenuItem(
                      icon: FontAwesomeIcons.userPen,
                      text: 'Edit Profile',
                      color: Colors.blue,
                      backgroundColor: const Color(0xFF102C57),
                      onTap: () {
                        Get.to(() => const EditProfileScreen());
                      },
                    ),
                    ProfileMenuItem(
                      icon: FontAwesomeIcons.cartShopping,
                      text: 'My Order',
                      color: Colors.orange,
                      backgroundColor: const Color(0xFF102C57),
                      onTap: () {
                        Get.to(() => const MyOrderScreen());
                      },
                    ),
                    ProfileMenuItem(
                      icon: FontAwesomeIcons.clockRotateLeft,
                      text: 'Order History',
                      color: Colors.green,
                      backgroundColor: const Color(0xFF102C57),
                      onTap: () {
                        Get.to(() => const OrderHistoryScreen());
                      },
                    ),
                    ProfileMenuItem(
                      icon: FontAwesomeIcons.heartCircleCheck,
                      text: 'Wishlist',
                      color: Colors.yellow,
                      backgroundColor: const Color(0xFF102C57),
                      onTap: () {
                        Get.to(() => const BookMarkScreen());
                      },
                    ),
                    ProfileMenuItem(
                      icon: FontAwesomeIcons.rightFromBracket,
                      text: 'Log Out',
                      color: Colors.red,
                      backgroundColor: const Color(0xFF102C57),
                      onTap: _showLogoutConfirmationDialog,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    required this.color,
    this.backgroundColor = Colors.white,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.1),
          onTap: onTap,
          child: ListTile(
            leading: FaIcon(icon, color: color),
            title: Text(
              text,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

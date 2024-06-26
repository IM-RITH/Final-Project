import 'dart:io';
import 'package:easyshop/const/stripe_api.dart';
import 'package:easyshop/controller/category_controller.dart';
import 'package:easyshop/controller/store_controller.dart';
import 'package:easyshop/usage/usage.dart';
import 'package:easyshop/views/onboardingscreen.dart';
import 'package:easyshop/views/screens/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeApi.stripePublicKey;
  // await Stripe.instance.applySettings();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDVTeq4qpYJhD3o6duNs1rb3WxeKe0xC_Y",
              appId: "1:726625939599:android:e20f4b92034ea6738b00fa",
              messagingSenderId: "726625939599",
              projectId: "easyshop-project-efff5",
              storageBucket: "gs://easyshop-project-efff5.appspot.com"),
        )
      : await Firebase.initializeApp();

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // delayed and navigate to another page
  await Future.delayed(
    const Duration(seconds: 1),
  );
  FlutterNativeSplash.remove();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _authCheck();
  }

  void _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Get.offAll(
          () => const OnboardingScreen(),
        );
      } else {
        Get.offAll(
          () => const MapScreen(),
        );
        loadUserCart(ref);
        loadUserFavorites(ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter E-Commerce app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      initialBinding: BindingsBuilder(
        () {
          Get.put<CategoryController>(
            CategoryController(),
          );
          Get.put<StoreController>(
            StoreController(),
          );
        },
      ),
    );
  }
}

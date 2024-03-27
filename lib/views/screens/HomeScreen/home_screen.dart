import "package:easyshop/views/screens/widget/banner_widget.dart";
import "package:easyshop/views/screens/widget/logo_widget.dart";
import "package:easyshop/views/screens/widget/search_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) => const Column(
        children: [
          LogoWidget(),
          SizedBox(height: 10.0),
          SearchWidget(),
          SizedBox(height: 12.0),
          BannerWidget(),
        ],
      ),
    );
  }
}

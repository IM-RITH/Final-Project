import 'package:easyshop/views/screens/widget/banner_widget.dart';
import 'package:easyshop/views/screens/widget/category_widget.dart';
import 'package:easyshop/views/screens/widget/logo_widget.dart';
import 'package:easyshop/views/screens/widget/recommend_product.dart';
import 'package:easyshop/views/screens/widget/store_widget.dart';
import 'package:easyshop/views/screens/widget/text_widget.dart';
import 'package:easyshop/views/screens/widget/search_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          // Fixed part
          LogoWidget(),
          SizedBox(height: 10.0),
          SearchWidget(),
          SizedBox(height: 12.0),

          // Scrollable part
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BannerWidget(),
                  SizedBox(height: 5.0),
                  CategoryWidget(),
                  SizedBox(height: 15.0),
                  StoreWidget(),
                  SizedBox(height: 10.0),
                  TextWidget(),
                  SizedBox(height: 1.0),
                  RecommendProduct(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

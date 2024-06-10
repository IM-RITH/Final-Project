import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easyshop/views/screens/widget/banner_widget.dart';
import 'package:easyshop/views/screens/widget/category_widget.dart';
import 'package:easyshop/views/screens/widget/logo_widget.dart';
import 'package:easyshop/views/screens/widget/recommend_product.dart';
import 'package:easyshop/views/screens/widget/store_widget.dart';
import 'package:easyshop/views/screens/widget/text_widget.dart';
import 'package:easyshop/views/screens/widget/search_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _refreshContent() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          // Fixed part
          const LogoWidget(),
          const SizedBox(height: 10.0),
          const SearchWidget(),
          const SizedBox(height: 12.0),

          // Scrollable and refreshable part
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshContent,
              child: const SingleChildScrollView(
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
          ),
        ],
      ),
    );
  }
}

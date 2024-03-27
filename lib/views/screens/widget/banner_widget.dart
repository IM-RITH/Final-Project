import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _bannerImages = [];
  int _current = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    QuerySnapshot querySnapshot = await _firestore.collection('banners').get();
    final List<String> imageUrls = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .map((data) => data['image'] as String)
        .toList();

    if (imageUrls.isNotEmpty) {
      setState(() {
        _bannerImages.addAll(imageUrls);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double bannerHeight = screenHeight * 0.15;
    return _bannerImages.isNotEmpty
        ? Column(
            children: [
              CarouselSlider(
                items: _bannerImages.map((imageUrl) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: bannerHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white38,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imageUrl),
                      ),
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: bannerHeight,
                  viewportFraction: 1.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  enlargeCenterPage: false,
                ),
                carouselController: _carouselController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _bannerImages.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _carouselController.animateToPage(entry.key),
                    child: Container(
                      width: 5.0,
                      height: 5.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_current == entry.key
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColor.withOpacity(0.4)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        : const SizedBox(
            // Placeholder widget
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
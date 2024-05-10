import 'package:easyshop/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartInfo = ref.watch(cartProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    TextStyle productNameStyle = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    TextStyle quantity = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      body: cartInfo.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600),
              ),
            )
          : Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  color: const Color(0xFF153167),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "You have ${cartInfo.length} ${cartInfo.length == 1 ? 'item' : 'items'}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartInfo.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartInfo.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: const Color(0xFF31363F),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      cartItem.imageUrlList[0],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          cartItem.productName,
                                          style: productNameStyle,
                                        ),
                                        const SizedBox(height: 10),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Size: ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: cartItem
                                                        .productSize.isNotEmpty
                                                    ? cartItem.productSize
                                                    : "N/A",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Color: ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                              TextSpan(
                                                text: cartItem
                                                        .productColor.isNotEmpty
                                                    ? cartItem.productColor
                                                    : "N/A",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Price: ',
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14),
                                              ),
                                              TextSpan(
                                                text:
                                                    '\$${cartItem.productPrice}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[800],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle,
                                              color: Colors.redAccent),
                                          onPressed: () {
                                            _cartProvider.decreseProductCount(
                                                cartItem.productId);
                                          },
                                        ),
                                        Text(
                                          '${cartItem.productQuantity}',
                                          style: quantity,
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Colors.greenAccent),
                                          onPressed: () {
                                            _cartProvider.increseProductCount(
                                                cartItem.productId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_rounded,
                                      color: Colors.white),
                                  onPressed: () {
                                    _cartProvider
                                        .removeItem(cartItem.productId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8A9418),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle checkout action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF012E87),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                        ),
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

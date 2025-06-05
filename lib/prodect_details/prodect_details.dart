import 'package:flutter/material.dart';
import 'package:flutter_project/home/home_page.dart';
import 'package:flutter_project/cart_page/cart_page.dart';
import 'package:flutter_project/search_prodects/search_prodects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;
  final List<Map<String, dynamic>> products;
  final List<Map<String, String>> categories;

  const ProductDetails({
    Key? key,
    required this.product,
    required this.products,
    required this.categories,
  }) : super(key: key);
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  Future<void> addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginUser = prefs.getString('logged_in_user');
    if (loginUser == null) {
      return;
    }

    final String cartKey = 'cartItems_$loginUser';
    final String? cartJson = prefs.getString(cartKey);

    List<Map<String, dynamic>> cart = [];

    if (cartJson != null) {
      final List decodedList = jsonDecode(cartJson);
      cart = decodedList
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    int existingIndex = cart.indexWhere(
      (item) => item['id'] == widget.product['id'],
    );

    if (existingIndex >= 0) {
      cart[existingIndex]['count'] += quantity;
    } else {
      Map<String, dynamic> newItem = Map<String, dynamic>.from(widget.product);
      newItem['count'] = quantity;
      cart.add(newItem);
    }

    await prefs.setString(cartKey, jsonEncode(cart));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.product['name']} added to cart!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 50,
                  height: 30,
                  color: Colors.black,
                ),
                Text(
                  'Elyousr',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(
                        widget.products
                            .map(
                              (product) => product.map(
                                (key, value) => MapEntry(key, value.toString()),
                              ),
                            )
                            .toList(),
                        widget.categories,
                      ),
                    );
                  },
                ),

                PopupMenuButton<String>(
                  onSelected: (String value) {
                    if (value == 'profile') {
                      Navigator.pushNamed(context, '/profile');
                    } else if (value == 'logout') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Logout"),
                            content: Text("Do you want to logout?"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Close"),
                              ),
                              TextButton(
                                onPressed: () {
                                  logout(context);
                                },
                                child: Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: "profile",
                      child: Row(
                        children: [Icon(Icons.person), Text("profile")],
                      ),
                    ),
                    PopupMenuItem(
                      value: "logout",
                      child: Row(
                        children: [Icon(Icons.logout), Text("Log Out")],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  product['image'],
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              Text(
                product['name'],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              SizedBox(height: 16),

              Text(
                product['description'] ?? 'No description available.',
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$ ${product['price']}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  SizedBox(width: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: decrementQuantity,
                      ),
                      Text('$quantity', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: incrementQuantity,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

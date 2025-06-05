import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Cart'), backgroundColor: Colors.white),
      body: cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(
                      'Go Shopping',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/orders');
                    },
                    child: Text(
                      "View My Orders",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(18),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  double price =
                      double.tryParse(item['price'].toString()) ?? 0.0;
                  double total = price * item['count'];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Card(
                      margin: EdgeInsets.symmetric(vertical: 8),

                      color: Colors.grey[100],
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,

                        leading: Image.asset(
                          item['image'] ?? 'assets/default_image.png',
                          width: 80,
                          height: 80,
                        ),
                        title: Text(item['name'] ?? 'Item'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total: \$${total.toStringAsFixed(2)}'),
                            Text('Quantity: ${item['count']}'),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => decrementQuantity(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => incrementQuantity(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeItem(index),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  placeOrder();
                },
                child: const Text(
                  'Place Order',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginUser = prefs.getString('logged_in_user');

    if (loginUser == null) {
      setState(() {
        cartItems = [];
      });
      return;
    }

    final String userCartKey = 'cartItems_$loginUser';

    final String? cartJson = prefs.getString(userCartKey);
    if (cartJson != null) {
      final List decodedList = jsonDecode(cartJson);
      setState(() {
        cartItems = decodedList
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
      });
    } else {
      setState(() {
        cartItems = [];
      });
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginUser = prefs.getString('logged_in_user');

    if (loginUser == null) {
      return;
    }

    final String userCartKey = 'cartItems_$loginUser';
    await prefs.setString(userCartKey, jsonEncode(cartItems));
  }

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]['count'] += 1;
    });
    saveCart();
  }

  void decrementQuantity(int index) {
    if (cartItems[index]['count'] > 1) {
      setState(() {
        cartItems[index]['count'] -= 1;
      });
      saveCart();
    }
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
    saveCart();
  }

  void placeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginUser = prefs.getString('logged_in_user');

    if (loginUser == null) return;

    final String ordersKey = 'orders_$loginUser';

    List<Map<String, dynamic>> currentOrder = List.from(cartItems);

    double total = 0;
    for (var item in currentOrder) {
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      total += price * item['count'];
    }

    Map<String, dynamic> order = {
      'items': currentOrder,
      'total': total,
      'date': DateTime.now().toIso8601String(),
    };

    final String? existingOrders = prefs.getString(ordersKey);
    List<Map<String, dynamic>> orders = [];

    if (existingOrders != null) {
      orders = List<Map<String, dynamic>>.from(json.decode(existingOrders));
    }

    orders.add(order);

    await prefs.setString(ordersKey, jsonEncode(orders));

    setState(() {
      cartItems.clear();
    });
    await saveCart();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Order Placed"),
        content: Text("Thank you for your purchase!"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

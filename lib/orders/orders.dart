import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_project/cart_page/cart_page.dart';
import 'package:flutter_project/home/home_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? loginUser = prefs.getString('logged_in_user');
    if (loginUser == null) return;

    final String ordersKey = 'orders_$loginUser';
    final String? ordersJson = prefs.getString(ordersKey);

    if (ordersJson != null) {
      final List decoded = jsonDecode(ordersJson);
      setState(() {
        orders = decoded
            .map((order) => Map<String, dynamic>.from(order))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],

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
      backgroundColor: Colors.grey[100],
      body: orders.isEmpty
          ? Center(child: Text('No orders placed yet.'))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Text(
                  'Your Orders',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final List items = order['items'];
                      final total = order['total'].toStringAsFixed(2);
                      final date = DateFormat(
                        'yyyy-MM-dd – kk:mm',
                      ).format(DateTime.parse(order['date']));

                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Date: $date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              ...items.map(
                                (item) => Text(
                                  '${item['name']} x${item['count']} - \$${(double.parse(item['price'].toString()) * item['count']).toStringAsFixed(2)}',
                                ),
                              ),
                              Divider(),
                              Text(
                                'Total: \$${total}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

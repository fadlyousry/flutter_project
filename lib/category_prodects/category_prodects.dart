import 'package:flutter/material.dart';
import 'package:flutter_project/home/home_page.dart';
import 'package:flutter_project/prodect_details/prodect_details.dart';
import 'package:flutter_project/cart_page/cart_page.dart';
import 'package:flutter_project/search_prodects/search_prodects.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> products;

  final List<Map<String, String>> categories;

  const CategoryProductsPage({
    Key? key,
    required this.categoryName,
    required this.products,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

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
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: ProductSearchDelegate(
                        products
                            .map(
                              (product) => product.map(
                                (key, value) => MapEntry(key, value.toString()),
                              ),
                            )
                            .toList(),
                        categories,
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(categoryName, style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: products.length > 8 ? 8 : products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            product: product,
                            products: products,
                            categories: categories,
                          ),
                        ),
                      );
                    },

                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18),
                                topRight: Radius.circular(18),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Image.asset(
                                  product['image']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${product['price']}',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}

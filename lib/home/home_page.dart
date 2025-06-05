//---------------------------------------------------------------------------------------------------------------
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project/category_prodects/category_prodects.dart';
import 'package:flutter_project/prodect_details/prodect_details.dart';
import 'package:flutter_project/search_prodects/search_prodects.dart';
import 'package:flutter_project/cart_page/cart_page.dart';

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove('logged_in_user');
  Navigator.pushReplacementNamed(context, '/login');
}

class HomePageWithPages extends StatefulWidget {
  const HomePageWithPages({super.key});

  @override
  State<HomePageWithPages> createState() => _HomePageWithPagesState();
}

class _HomePageWithPagesState extends State<HomePageWithPages> {
  String userName = 'Guest';

  final List<String> promoImages = [
    'assets/l12.png',
    'assets/l11.png',
    'assets/l14.png',
    'assets/l13.png',
  ];

  final List<Map<String, String>> Products = [
    {
      'name': 'T-Shirt',
      'image': 'assets/pro1.png',
      'categories': "men's",
      'price': '200.0',
      'featuredProduct': 'false',
      'id': '1',
      "description":
          "Cozy and stylish men's winter jacket made of wool blend, perfect for cold weather. Features an inner lining, button closure, and a modern fit.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro2.png',
      'categories': "men's",
      'price': '180.0',
      'featuredProduct': 'false',
      'id': '2',
      "description":
          "Classic tailored men's suit ideal for business meetings and formal occasions. Includes jacket and trousers.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro3.png',
      'categories': "men's",
      'price': '220.0',
      'featuredProduct': 'false',
      'id': '3',
      "description":
          "Classic tailored men's suit ideal for business meetings and formal occasions. Includes jacket and trousers.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro4.png',
      'categories': "men's",
      'price': '210.0',
      'featuredProduct': 'true',
            'id': '4',

      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'shirt',
      'image': 'assets/pro5.png',
      'categories': "men's",
      'price': '250.0',
      'featuredProduct': 'true',
      'id': '5',
      "description":
          "Comfortable oversized T-shirt made for everyday casual wear. Unisex fit with modern streetwear style.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro6.png',
      'categories': "men's",
      'price': '180.0',
      'featuredProduct': 'false',
      'id': '6',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'collared t-shirt',
      'image': 'assets/pro7.png',
      'categories': "men's",
      'price': '190.0',
      'featuredProduct': 'false',
      'id': '7',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro8.png',
      'categories': "men's",
      'price': '200.0',
      'featuredProduct': 'false',
      'id': '8',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'Shirt',
      'image': 'assets/pro9.png',
      'categories': "men's",
      'price': '160.0',
      'featuredProduct': 'false',
      'id': '9',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro10.png',
      'categories': "men's",
      'price': '320.0',
      'featuredProduct': 'false',
      'id': '10',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'T-Shirt',
      'image': 'assets/pro11.png',
      'categories': "men's",
      'price': '340.0',
      'featuredProduct': 'false',
      'id': '11',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'jeans',
      'image': 'assets/pro12.png',
      'categories': "men's",
      'price': '260.0',
      'featuredProduct': 'false',
      'id': '12',
      "description":
          "Comfortable oversized T-shirt made for everyday casual wear. Unisex fit with modern streetwear style.",
    },
    {
      'name': 'jeans',
      'image': 'assets/pro13.png',
      'categories': "men's",
      'price': '290.0',
      'featuredProduct': 'true',
      'id': '13',
      "description":
          "Comfortable oversized T-shirt made for everyday casual wear. Unisex fit with modern streetwear style.",
    },
    {
      'name': 'jeans',
      'image': 'assets/pro14.png',
      'categories': "men's",
      'price': '120.0',
      'featuredProduct': 'false',
      'id': '14',
      "description":
          "Comfortable oversized T-shirt made for everyday casual wear. Unisex fit with modern streetwear style.",
    },
    {
      'name': 'collared t-shirt',
      'image': 'assets/pro15.png',
      'categories': "men's",
      'price': '235.0',
      'featuredProduct': 'true',
      'id': '15',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'collared t-shirt',
      'image': 'assets/pro14.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',

      "id": '16',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'Shirt',
      'image': 'assets/pro13.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      "id": '17',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'jeans',
      'image': 'assets/pro12.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      "id": '18',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'collared t-shirt',
      'image': 'assets/pro11.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '19',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/pro2.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/pro3.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/pro1.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/pro7.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/pro10.png',
      'categories': "children's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'shirt 2',
      'image': 'assets/w12.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'shirt 3',
      'image': 'assets/w2.png',
      'categories': "women's",
      'price': '150.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' shirt 3',
      'image': 'assets/w13.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'shirt 5',
      'image': 'assets/w4.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': 'shirt 6',
      'image': 'assets/w5.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/w6.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/w7.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/w8.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/w9.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
    {
      'name': ' t-shirt',
      'image': 'assets/w10.png',
      'categories': "women's",
      'price': '235.0',
      'featuredProduct': 'false',
      'id': '20',
      "description":
          "This graphic t-shirt which is perfect for any occasion. Crafted from a soft and breathable fabric, it offers superior comfort and style.",
    },
  ];
  final List<Map<String, String>> categories = [
    {'image': 'assets/image6.png', 'categories': "Men's"},
    {'image': 'assets/w13.png', 'categories': "women's"},
    {'image': 'assets/pro6.png', 'categories': "children's"},
    {'image': 'assets/l14.png', 'categories': "polo"},
    {'image': 'assets/bag.png', 'categories': "Bags"},
    {'image': 'assets/w10.png', 'categories': "Shoes"},
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadUserName();
  }

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedInEmail = prefs.getString('logged_in_user');
    if (loggedInEmail != null) {
      final userData = prefs.getString('user_$loggedInEmail');
      if (userData != null) {
        final userMap = Map<String, dynamic>.from(jsonDecode(userData));
        setState(() {
          userName = userMap['fullName'] ?? 'Guest';
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                      delegate: ProductSearchDelegate(Products, categories),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "welcome back, $userName !",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 180,

                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: promoImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: const Color.fromARGB(
                                    255,
                                    239,
                                    239,
                                    239,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image.asset(
                                          promoImages[index],
                                          fit: BoxFit.cover,
                                          height: 180,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Products
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      height: 400,
                      child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 10,
                        children:
                            Products.where(
                              (product) => product['featuredProduct'] == "true",
                            ).map((product) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        product: product,
                                        products: Products,
                                        categories: categories,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.asset(
                                            width: 150,
                                            product['image']!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(product['name']!),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // Categories + New Arrivals
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((cat) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                final filteredProducts = Products.where((
                                  product,
                                ) {
                                  return product['categories']?.toLowerCase() ==
                                      (cat['categories']?.toLowerCase() ?? '');
                                }).toList();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CategoryProductsPage(
                                      categoryName: cat['categories'] ?? '',
                                      products: filteredProducts,
                                      categories: categories,
                                    ),
                                  ),
                                );
                              },
                              child: Text(cat['categories'] ?? ''),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 24),

                    Text(
                      "New Arrivals",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: Products.sublist(Products.length - 4).map((
                          product,
                        ) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    product: product,
                                    products: Products,
                                    categories: categories,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: 120,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name']!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '\$${product['price']}',
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

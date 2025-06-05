import 'package:flutter/material.dart';
import 'package:flutter_project/prodect_details/prodect_details.dart';

class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> products;
  final List<Map<String, String>> categories;

  ProductSearchDelegate(this.products, this.categories);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = products.where((product) {
      final name = product['name']?.toLowerCase() ?? '';
      return name.contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 120, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No products found for "$query"',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final product = results[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Card(
              color: Colors.grey[100],
              child: ListTile(
                leading: Image.asset(product['image']!, width: 50, height: 50),
                title: Text(product['name']!),
                subtitle: Text('\$${product['price']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetails(
                        product: product,
                        products: products,
                        categories: categories,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      final results = products.where((product) {
        final name = product['name']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      return Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                color: Colors.grey[100],
                child: ListTile(
                  leading: Image.asset(
                    product['image']!,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(product['name']!),
                  subtitle: Text('\$${product['price']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetails(
                          product: product,
                          products: products,
                          categories: categories,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: categories.map((category) {
          final categoryName = category['categories']!;
          final categoryImage = category['image']!;
          return GestureDetector(
            onTap: () {
              final filteredProducts = products.where((product) {
                return product['categories']?.toLowerCase() ==
                    categoryName.toLowerCase();
              }).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    backgroundColor: Colors.white,

                    appBar: AppBar(title: Text(categoryName)),
                    body: Container(
                      color: Colors.white,
                      child: ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Card(
                              color: Colors.grey[100],
                              child: ListTile(
                                leading: Image.asset(
                                  product['image']!,
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(product['name']!),
                                subtitle: Text('\$${product['price']}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProductDetails(
                                        product: product,
                                        products: products,
                                        categories: categories,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
         
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        categoryImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

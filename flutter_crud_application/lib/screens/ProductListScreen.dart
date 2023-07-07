import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'products.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        productList = data.map((item) => Product.fromJson(item)).toList();
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> createProduct() async {
    final product = Product(
      productName: 'New Product',
      productCode: 'P001',
      img: 'https://media.zigcdn.com/media/model/2021/May/v8_360x240.jpg',
      unitPrice: '9.99',
      qty: '10',
      totalPrice: '99.90',
    );

    final response = await http.post(
      Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct'),
      body: json.encode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final createdProduct = Product.fromJson(json.decode(response.body));
      setState(() {
        productList.add(createdProduct);
      });
    } else {
      throw Exception('Failed to create product');
    }
  }

  Future<void> updateProduct(Product product) async {
    // Assuming you have a way to edit the product details, such as a form or dialog
    final updatedProduct = Product(
      productName: 'Updated Product',
      productCode: 'P002',
      img: 'https://example.com/updated_image.jpg',
      unitPrice: '19.99',
      qty: '5',
      totalPrice: '99.95',
    );

    final response = await http.put(
      Uri.parse('https://crud.teamrabbil.com/api/v1/UpdateProduct/${product.productCode}'),
      body: json.encode(updatedProduct.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final index = productList.indexWhere((p) => p.productCode == product.productCode);
      setState(() {
        productList[index] = updatedProduct;
      });
    } else {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(Product product) async {
    final response = await http.delete(
      Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/${product.productCode}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        productList.removeWhere((p) => p.productCode == product.productCode);
      });
    } else {
      throw Exception('Failed to delete product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product CRUD'),
      ),
      body: ListView.builder(
        itemCount: productList.length,
        itemBuilder: (context, index) {
          final product = productList[index];
          return ListTile(
            leading: Image.network(product.img),
            title: Text(product.productName),
            subtitle: Text(product.productCode),
            trailing: Text('\$${product.totalPrice}'),
            onTap: () {
              updateProduct(product);
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Product'),
                    content: const Text('Are you sure you want to delete this product?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteProduct(product);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createProduct();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

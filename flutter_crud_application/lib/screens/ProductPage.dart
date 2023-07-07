import 'dart:convert';

import 'package:flutter/material.dart';

import 'AddNewProductPage.dart';
import 'package:http/http.dart';

import 'Product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: productList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onLongPress: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.only(left: 16),
                      contentPadding:
                      const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      title: Row(
                        children: [
                          const Text('Choose an action'),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            onTap: () {},
                            leading: const Icon(Icons.edit),
                            title: const Text("Tap here for edit"),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ListTile(
                            onTap: () {},
                            leading: const Icon(Icons.delete),
                            title: const Text("Tap here for delete"),
                          ),
                        ],
                      ),
                    );
                  });
            },
            leading: Image.network(
              productList[index].img,
              width: 50,
              errorBuilder: (_, __, ___) {
                return const Icon(Icons.image);
              },
            ),
            title: Text(productList[index].productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product Code: ${productList[index].productCode}'),
                Text('Unit Price: ${productList[index].unitPrice}'),
                Text('Available Units: ${productList[index].qty}'),
              ],
            ),
            trailing: Text('Total Price: ${productList[index].totalPrice}'),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> fetchData() async {
    final Response response =
    await get(Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct'));
    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (response.statusCode == 200 && decodedResponse['status'] == 'success') {
      for (var it in decodedResponse['data']) {
        productList.add(Product(
            it['_id'],
            it['ProductName'],
            it['ProductCode'],
            it['Img'],
            it['UnitPrice'],
            it['Qty'],
            it['TotalPrice'],
            it['CreatedDate']));
        if (mounted) {
          setState(() {});
        }
      }
    }
    print(productList.length);
    print(decodedResponse['data'].length);
    print(response.statusCode);
    print(response.body);
  }
}

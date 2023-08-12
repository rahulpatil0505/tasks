// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasks/Task1/model/Product_list.dart';
import 'package:tasks/Task1/model/Screens/Input.dart';

import 'Cart.dart';
import 'Search.dart';

class ProductShow extends StatefulWidget {
  const ProductShow({
    super.key,
  });

  @override
  State<ProductShow> createState() => _ProductShowState();
}

class _ProductShowState extends State<ProductShow> {
  List<Map<String, dynamic>> allProductShow = [];
  bool isLoading = true;
  // Cart cart = Cart();

  void refreshProductShows() async {
    final data = await SQLHelper.getAllCompanyDetails();
    setState(() {
      allProductShow = data;
      isLoading = false;
    });
    setState(() {
      if (allProductShow.isEmpty) isLoading = true;
    });
  }

  @override
  void initState() {
    refreshProductShows();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      refreshProductShows();
    });
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: const Text(
            "Product",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 113, 152, 150),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Search()));
                },
                child: const Icon(
                  CupertinoIcons.search,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()
                          // ShowCartPage(cart: cart),
                          ));
                },
                child: const Icon(
                  CupertinoIcons.cart_badge_plus,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 113, 152, 150),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddnewProductList()));
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Product"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: allProductShow.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {},
                      child: DataCard(
                        name: allProductShow[index]['name'],
                        sku: allProductShow[index]['sku'],
                        price: allProductShow[index]['price'],
                        length: allProductShow[index]['length'],
                        width: allProductShow[index]['width'],
                        height: allProductShow[index]['height'],
                        volumetricWeight: allProductShow[index]
                            ['volumetricWeight'],
                        category: allProductShow[index]['category'],
                        imagePath: allProductShow[index]['imagePath'],
                        minQty: allProductShow[index]['minQty'],
                        maxQty: allProductShow[index]['maxQty'],
                        id: allProductShow[index]['id'],
                        // cart: cart,
                      ));
                }));
  }
}

class DataCard extends StatefulWidget {
  // final Cart cart;
  final id,
      name,
      sku,
      price,
      length,
      width,
      height,
      volumetricWeight,
      category,
      imagePath,
      minQty,
      maxQty;
  const DataCard({
    super.key,
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.length,
    required this.width,
    required this.height,
    required this.volumetricWeight,
    required this.category,
    required this.imagePath,
    required this.minQty,
    required this.maxQty,
    // required this.cart,
  });

  @override
  State<DataCard> createState() => _DataCardState();
}

class _DataCardState extends State<DataCard> {
  displayMessage(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }

  Future<void> prdocutdelete_list(
    int id,
  ) async {
    await SQLHelper.productdelete(id);
    displayMessage("Product Deleted...");
  }

  int quantity = 1;

  void _addToCart() async {
    await SQLHelper.addToCart(
        widget.id,
        widget.name,
        quantity,
        widget.sku,
        widget.price,
        widget.category,
        widget.imagePath,
        widget.length,
        widget.width,
        widget.height,
        widget.volumetricWeight);
    displayMessage("Product added to cart!");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
          height: 130,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 3,
                      top: 15,
                    ),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1,
                              color: const Color.fromARGB(255, 11, 56, 93))),
                      width: 80,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            File(
                              widget.imagePath,
                            ),
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                          'SKU: ${widget.sku}\nCategory: ${widget.category}\nPrice:₹${widget.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 70,
                        ),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                prdocutdelete_list(widget.id);
                              });
                            },
                            icon: const Icon(
                              CupertinoIcons.delete,
                              size: 25,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 113, 152, 150),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 252, 246, 248),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                title: const Text("Add to Cart"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Select quantity:"),
                                    DropdownButton<int>(
                                      elevation: 10,
                                      value: quantity,
                                      onChanged: (value) {
                                        setState(() {
                                          quantity = value!;
                                        });
                                      },
                                      items: List.generate(10, (index) {
                                        return DropdownMenuItem<int>(
                                          value: index + 1,
                                          child: Text((index + 1).toString()),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 221, 86, 77),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.of(context).pop();
                                  //   },
                                  //   child: Text("Cancel"),
                                  // ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 113, 152, 150),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      _addToCart();
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Add to Cart'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('🛒 Cart'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

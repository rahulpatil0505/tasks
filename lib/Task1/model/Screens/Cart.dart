// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tasks/Task1/model/Product_list.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

// calculate subtotal
  double getSubtotal() {
    double subtotal = 0;
    for (var cartItem in cartItems) {
      subtotal += cartItem['price'] * cartItem['quantity'];
    }
    return subtotal;
  }

  double getShippingCharge() {
    double volumetricWeight = 0;
    for (var cartItem in cartItems) {
      volumetricWeight += cartItem['volumetricWeight'] * cartItem['quantity'];
    }

    double shippingCharge = 80 * volumetricWeight;

    // Check if the calculated shipping charge is less than the minimum (50 Rupees).
    if (shippingCharge < 50) {
      // Multiply the minimum shipping charge by the total quantity of cart items.
      return 50 *
          cartItems.fold(0, (total, cartItem) => total + cartItem['quantity']);
    }

    // Multiply the shipping charge by the total quantity of cart items.
    return shippingCharge *
        cartItems.fold(0, (total, cartItem) => total + cartItem['quantity']);
  }

  void refreshCartItems() async {
    final data = await SQLHelper.getAllCartDetails();
    setState(() {
      cartItems = data;
      isLoading = false;
    });
    setState(() {
      if (cartItems.isEmpty) isLoading = true;
    });
  }

  @override
  void initState() {
    refreshCartItems();
    super.initState();
  }

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

  Future<void> deleteproduct_list2(
    int id,
  ) async {
    await SQLHelper.deleteaddToCart(id);
    setState(() {
      displayMessage("Product Deleted...");
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      refreshCartItems();
    });
    double subtotal = getSubtotal();
    double volumetricWeight = 5;
    double shippingCharge = getShippingCharge();
    double totalAmount = subtotal + shippingCharge;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: const Color.fromARGB(255, 113, 152, 150),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Image.asset("assets/cart.png"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      final productName = cartItem['name'] ??
                          'Unknown Product'; // Use 'Unknown Product' if 'name' is null
                      return Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        top: 12,
                                      ),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              width: 1,
                                              color: const Color.fromARGB(
                                                  255, 113, 152, 150),
                                            )),
                                        width: 70,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.file(
                                              File(
                                                cartItem['imagePath'],
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productName,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                            'sku: ${cartItem['sku']}\nCategory: ${cartItem['category']}\nPrice:₹${cartItem['price'].toStringAsFixed(2)}\nQuantity: ${cartItem['quantity']}'),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  deleteproduct_list2(
                                                      cartItem['id']);
                                                });
                                              },
                                              icon: const Icon(
                                                CupertinoIcons.delete,
                                                size: 25,
                                              )),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                      );
                    },
                  ),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15.00)),
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 10.00,
                    child: Column(
                      children: [
                        rowwidget('Subtotal:',
                            '₹${getSubtotal().toStringAsFixed(2)}'),
                        const SizedBox(
                          height: 10,
                        ),
                        rowwidget('Shipping Charge:',
                            '₹${shippingCharge.toStringAsFixed(2)}'),
                        const SizedBox(
                          height: 10,
                        ),
                        rowwidget('Total Amount:',
                            '₹${totalAmount.toStringAsFixed(2)}')
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  //row widget
  rowwidget(String text, String totals) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Text(
            totals,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          )
        ],
      ),
    );
  }
}

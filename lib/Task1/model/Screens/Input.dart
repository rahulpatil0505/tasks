// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasks/Task1/model/Product_list.dart';

class AddnewProductList extends StatefulWidget {
  const AddnewProductList({super.key});

  @override
  State<AddnewProductList> createState() => _AddNewCompanyListPageState();
}

class _AddNewCompanyListPageState extends State<AddnewProductList> {
  var name = "";
  var sku = "";
  late double price;
  late double length;
  late double width;
  late double height;
  late double volumetricWeight;
  var category = "";
  var imagePath = "";
  late int minQty;
  late int maxQty;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  final TextEditingController _minQtyController = TextEditingController();
  final TextEditingController _maxQtyController = TextEditingController();
  final TextEditingController _volumetricWeightController =
      TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _categoryController.dispose();
    _imagePathController.dispose();
    _minQtyController.dispose();
    _maxQtyController.dispose();
    _volumetricWeightController.dispose();
    super.dispose();
  }

  clearText() {
    _nameController.clear();
    _skuController.clear();
    _priceController.clear();
    _lengthController.clear();
    _widthController.clear();
    _heightController.clear();
    _categoryController.clear();
    _imagePathController.clear();
    _minQtyController.clear();
    _maxQtyController.clear();
    _volumetricWeightController.clear();
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
    Navigator.pop(context);
  }

  Future<void> addCompany_List(
    String name,
    String sku,
    double price,
    double length,
    double width,
    double height,
    double volumetricWeight,
    String category,
    String imagePath,
    int minQty,
    int maxQty,
  ) async {
    await SQLHelper.addproduct(name, sku, price, length, width, height,
        volumetricWeight, category, imagePath, minQty, maxQty);

    displayMessage("Product Details Added...");
  }

  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Produts",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 113, 152, 150),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Name',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'SKU',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an SKU';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Price',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price';
                    }
                    final price = double.tryParse(value);
                    if (price == null || price <= 0) {
                      return 'Price should be a positive number';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _lengthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Length',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a length';
                    }
                    final length = double.tryParse(value);
                    if (length == null || length <= 0) {
                      return 'Price should be a length';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _widthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Width',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a width';
                    }
                    final width = double.tryParse(value);
                    if (width == null || width <= 0) {
                      return 'Price should be a width';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _heightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Height',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a height';
                    }
                    final height = double.tryParse(value);
                    if (height == null || height <= 0) {
                      return 'Price should be a height';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'Category',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a category';
                    }

                    if (value != null && value.isEmpty) {
                      return 'Price should be a category';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.00),
                      border: Border.all(width: 1.00, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: _image != null
                            ? Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15.00)),
                                height: 50,
                                width: 70,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.fill,
                                    )),
                              )
                            : Container(
                                child: const Center(
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 113, 152, 150),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: InkWell(
                          onTap: _pickImage,
                          child: const Icon(
                            CupertinoIcons.photo_on_rectangle,
                            size: 35,
                            color: Color.fromARGB(255, 113, 152, 150),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _minQtyController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'minQty',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a minQty';
                    }

                    if (value != null && value.isEmpty) {
                      return 'Price should be a minQty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _maxQtyController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      labelText: 'maxQty',
                      labelStyle: const TextStyle(fontSize: 15)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a maxQty';
                    }

                    if (value != null && value.isEmpty) {
                      return 'Price should be a maxQty';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 55,
                width: 160,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 113, 152, 150),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      setState(() {
                        name = _nameController.text;
                        sku = _skuController.text;
                        price = double.parse(_priceController.text);
                        length = double.parse(_lengthController.text);
                        width = double.parse(_widthController.text);
                        height = double.parse(_heightController.text);
                        volumetricWeight =
                            (double.parse(_lengthController.text) *
                                double.parse(_widthController.text) *
                                double.parse(_heightController.text) /
                                5000);
                        category = _categoryController.text;
                        imagePath = _image.toString();
                        minQty = int.parse(_minQtyController.text);
                        maxQty = int.parse(_maxQtyController.text);
                        addCompany_List(
                            name,
                            sku,
                            price,
                            length,
                            width,
                            height,
                            volumetricWeight,
                            category,
                            _image != null ? _image!.path : "",
                            minQty,
                            maxQty);
                        clearText();
                      });
                    },
                    child: const Text(
                      "Add Product",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      return null;
    }
  }
}

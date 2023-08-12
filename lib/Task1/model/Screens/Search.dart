import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasks/Task1/model/Product_list.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 113, 152, 150),
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _searchController,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: Color.fromARGB(255, 113, 152, 150), width: 1.0),
                  ),
                  suffix: InkWell(
                      onTap: () {
                        _searchController.clear();
                      },
                      child: const Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.red,
                        size: 30,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                  labelText: 'Search',
                  labelStyle: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 113, 152, 150),
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: SizedBox(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  top: 15,
                                ),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color: const Color.fromARGB(
                                            255, 113, 152, 150),
                                      )),
                                  width: 70,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.file(
                                        File(
                                          _searchResults[index]['imagePath'],
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
                                    _searchResults[index]['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                      'SKU: ${_searchResults[index]['sku']}\nCategory: ${_searchResults[index]['category']}\nPrice:₹${_searchResults[index]['price'].toStringAsFixed(2)}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSearchTextChanged(String value) async {
    List<Map<String, dynamic>> results =
        await SQLHelper.searchProducts(value.trim());
    setState(() {
      _searchResults = results;
    });
  }
}

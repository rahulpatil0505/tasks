import 'package:flutter/material.dart';
import 'package:tasks/Task1/model/Screens/Show.dart';

import 'Task2/Sedule.dart';

class Connections extends StatefulWidget {
  const Connections({super.key});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 45,
              width: 180,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductShow(),
                        ));
                  },
                  child: const Text("Task -1"))),
          const SizedBox(
            height: 40,
          ),
          Container(
              height: 45,
              width: 180,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VetScheduleScreen(),
                        ));
                  },
                  child: const Text("Task -2")))
        ],
      ),
    );
  }
}

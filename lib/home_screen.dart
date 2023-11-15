import 'package:flutter/material.dart';
import 'package:tensorflow_showcase/feature_box.dart';

import 'features.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome to tensorflow'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
              itemCount: featureMap.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: FeatureBox(
                      color: Colors.orangeAccent,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                featureMap[index]['widget'] as Widget));
                      },
                      text: featureMap[index]['name'].toString(),
                      icon: featureMap[index]['icon'] as IconData),
                );
              }),
        ));
  }
}

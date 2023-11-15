/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:search_insights/qa.dart';
import 'package:search_insights/ui/qa_detail.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BertQA',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SearchInsightsScreen(),
    );
  }
}

class SearchInsightsScreen extends StatefulWidget {
  const SearchInsightsScreen({
    super.key,
  });

  @override
  State<SearchInsightsScreen> createState() => _SearchInsightsScreenState();
}

class _SearchInsightsScreenState extends State<SearchInsightsScreen> {
  QA? _qa;

  @override
  void initState() {
    _jsonDecode();
    super.initState();
  }

  void _jsonDecode() async {
    String qaJson =
        await rootBundle.loadString("packages/search_insights/assets/qa.json");
    setState(() {
      _qa = QA.fromJson(json.decode(qaJson));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    const AssetImage('assets/images/banner_lite.png').assetName,
                    package: 'search_insights',
                  ),
                  const Positioned(
                      top: 76,
                      left: 32,
                      child: Text(
                        "TFL Question and Answer",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Please select an article below.",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
              Expanded(
                  child: ListView.separated(
                itemCount: _qa?.titles?.length ?? 0,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_qa?.titles![index].toString() ?? ""),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (_qa != null) {
                          return QaDetail(
                              title: _qa!.titles![index],
                              content: _qa!.contents![index],
                              questions: _qa!.questions![index]);
                        } else {
                          return const Text("No data to display");
                        }
                      }));
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 1, color: Colors.grey.shade100);
                },
              )),
            ],
          ),
        ));
  }
}

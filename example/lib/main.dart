import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:flutter_chromaprint/flutter_chromaprint.dart';
import 'dart:io';

void main() {
      final executable = File(Platform.executable);
      final lib = '${executable.parent.path}/Frameworks/chromaprint.framework/chromaprint';
  DynamicLibrary.open(lib);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterChromaprintApi = ChromaprintApi();
  String version = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app 2'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () {
                    version = _flutterChromaprintApi.getVersion();
                    print(version);
                  },
                  child: Text("Get Chromaprint Version")),
              Text(version)
            ],
          ),
        ),
      ),
    );
  }
}

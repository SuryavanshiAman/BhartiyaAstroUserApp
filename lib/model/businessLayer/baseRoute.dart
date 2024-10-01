// ignore_for_file: prefer_const_constructors_in_immutables


import 'package:flutter/material.dart';


class BaseRoute extends StatelessWidget {
  final dynamic a;
  final dynamic o;
  final String r;

  // ignore: use_key_in_widget_constructors
  BaseRoute({this.a, this.o, required this.r});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  Future addAnalytics() async {
    a.setCurrentScreen(screenName: r);
  }

}

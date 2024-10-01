import 'package:flutter/material.dart';

class KundliGender{
  String title;
  bool isSelected;
  String image;
  KundliGender({required this.title,required this.isSelected,required this.image});
}

class Kundli{
  IconData icon;
  bool isSelected;
  Kundli({required this.icon,required this.isSelected});
}
class KundliDetailTab{
  String title;
  bool isSelected;
  KundliDetailTab({required this.title,required this.isSelected});
}

class KundliDetails{
  String title;
  String value;
  KundliDetails({required this.title,required this.value});
}
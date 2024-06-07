// ignore_for_file: file_names
import 'package:flutter/material.dart';

class Message {
  String text;
  DateTime date;
  bool isSentByMe;
  String time;
  String seenStatus;
  ImageProvider? selectedImage;

  Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
    required this.time,
    required this.seenStatus,
    required this.selectedImage,
  });
}

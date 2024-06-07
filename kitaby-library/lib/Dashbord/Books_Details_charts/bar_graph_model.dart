import 'package:flutter/material.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';

class BarGraphModel{
  final String label;
  final Color color;
  final List<GraphModel> graph;

  BarGraphModel({required this.label, required this.color, required this.graph});
}
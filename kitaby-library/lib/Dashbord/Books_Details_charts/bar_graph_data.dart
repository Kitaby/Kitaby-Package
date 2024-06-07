import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/bar_graph_model.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';

class BarGraphData{
  final data =BarGraphModel(
                label: 'Books Details',
                color: ColorPalette.Primary_Color_Light,
                graph: [
                  GraphModel(x:0 , y: 1),
                  GraphModel(x:1, y: 5),
                  GraphModel(x:2 , y: 60),
                  GraphModel(x:3 , y: 4),
                  GraphModel(x:4 , y: 0),
                  GraphModel(x:5 , y: 10),
                  GraphModel(x:6 , y: 35),
                  GraphModel(x:7, y: 7),
                  GraphModel(x:8 , y: 22),
                  GraphModel(x:9 , y: 4),
                  GraphModel(x:10 , y: 10),
                  GraphModel(x:11 , y: 1),
                ]);
      

  final label =[
  "mystery",
  "biography",
  "history",
  "drama",
  "fiction",
  "romance",
  "adventure",
  "horror",
  "comedy",
  "science",
  "philosophy",
  "religious"
];

 final lefttitle ={
  0:'0 %',
  20:'20 %',
  40:'40 %',
  60:'60%',
  80:'80 %',
  100:'100 %',
 };


}
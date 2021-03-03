import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'sales.dart';

class SalesReportScreen extends StatefulWidget {
  SalesReportScreen({Key key}) : super(key: key);

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  var chartDisplay, chartDisplay2;

  List<charts.Series<Sales, String>> seriesBarData;

  @override
  void initState() {
    super.initState();
    seriesBarData = getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.40,
          child: charts.BarChart(
            seriesBarData,
            vertical: true,
            animate: true,
            animationDuration: Duration(
              microseconds: 2000,
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<Sales, String>> getData() {
    
      var data = [
        Sales("Women Clothing", 50),
        Sales("Men Clothing", 100),
        Sales("Men Shoes", 100)
      ];

      var data2 = [
        Sales("Women Clothing", 50),
        Sales("Men Clothing", 200),
        Sales("Men Shoes", 10)
      ];

      return [
        charts.Series<Sales, String>(
          id: 'Sales',
          data: data,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => sales.totsales,
        ),

        charts.Series<Sales, String>(
          id: 'Sales',
          data: data2,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => sales.totsales,
        ),
      ];
    
  }
}

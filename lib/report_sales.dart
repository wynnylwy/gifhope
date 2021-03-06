import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'sales.dart';

class SalesReportScreen extends StatefulWidget {
  SalesReportScreen({Key key}) : super(key: key);

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  List<charts.Series<Sales, String>> seriesBarData;
  List<Sales> salesData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
      ),
      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                // Chart title
                title: ChartTitle(text: 'Sales'),
                // Enable legend
                legend: Legend(isVisible: false),
                // Enable tooltip
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<Sales, String>>[
                  BarSeries<Sales, String>(
                      dataSource: salesData, // Deserialized Json data list.
                      xValueMapper: (Sales sales, _) => sales.genre,
                      yValueMapper: (Sales sales, _) => int.parse(sales.totsales),
                      // Enable data label
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ])),
      ),
    );
  }

  Future getData() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesDonation.php";
    await http.get(urlLoadJobs).then((res) {
      print(res.body);

      if (res.body.contains("nodata")) {
        setState(() {
          salesData = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          //salesData = extractdata["sales"];

          for (Map i in extractdata) {
            salesData.add(Sales.fromJson(i));
          }
        });
      }

      return salesData;
    }).catchError((err) {
      print(err);
    });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'sales.dart';

class SalesReportScreen extends StatefulWidget {
  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {

  

  List salesData; 
  List<charts.Series<Sales, String>> seriesBarData;

  @override
  void initState() { 
    super.initState();
    _getSalesDonateData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sales Report")),
      body: salesData == null 
               ? CircularProgressIndicator()
               : createChart(),
      
    );
  }

  _getSalesDonateData() async {
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
          salesData = extractdata["sales"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  createChart() {  
    List <charts.Series<Sales, String>> seriesList = [];

    for (int i=0; i< salesData.length; i++)
    {
     // String genre = salesData[i]['genre'];
      seriesList.add(createSeries(i ));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }

  charts.Series<Sales, String> createSeries( int i) //properties of bar chart
  {
    return charts.Series<Sales, String> (
      id: 'Sales',
      domainFn: (Sales sales, _) => sales.genre.toString(), 
      measureFn: (Sales sales, _) => sales.totsales, 
       
      data: [
        Sales(salesData[i]['sales']),
        Sales(salesData[i]['sales']),
        Sales(salesData[i]['sales']),
      ],

    );
    
  }
}

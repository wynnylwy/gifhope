import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'salesdonate.dart';

class SalesReportScreen extends StatefulWidget {
  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {

  List chartsData;
  List <charts.Series> chartSeries;

  String titlecenter = "Loading charts data...";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }

  _loadSalesDonateData () async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_salesDonation.php";

    await http.get(urlLoadJobs).then((res){

      print(res.body);

      if (res.body.contains("nodata"))
      {
        setState((){
          chartsData = null;
          titlecenter = "No Data";
        });
      }

      else 
      {
        setState((){
          var extractdata = json.decode(res.body);
          chartsData = extractdata["sales"];
        });
      }

    }).catchError((err){
      print(err);
    });
  }

  List<charts.Series<SalesDonate, String>> loadSalesDetails(int index) {

    
    
  }
}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import 'sales.dart';

class SalesReportScreen extends StatefulWidget {
  SalesReportScreen({Key key}) : super(key: key);

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  List<charts.Series<Sales, String>> seriesBarData;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.40,
          child: FutureBuilder(
              future: getData(),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.none || snapshot.hasData == false)
                {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                }

                else 
                {
                  return new charts.BarChart(
                    dataList (snapshot.data),
                    vertical: true,
                    animate: true,
                    barGroupingType: charts.BarGroupingType.grouped,
                    behaviors: [new charts.SeriesLegend(
                      position: charts.BehaviorPosition.top,
                      horizontalFirst: false,  //legend show vertically

                    )],
                    animationDuration: Duration(
                      microseconds: 2000,
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  Future getData() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesDonation.php";
    final res = await http.get(urlLoadJobs);

      if (res.body.contains("nodata")) 
      {
        return false;
      } 
      
      else 
      {
        Map<String, dynamic> map = json.decode(res.body);  //json decode will return dynamic
        final List<dynamic> salesData = map["sales"].toList();

        return salesData;
      }
    }
}

List<charts.Series<Sales, String>> dataList(List<dynamic> apiData) 
{
  List<Sales> list = new List();

  for (int i=0; i< apiData.length; i++)
  {
  
    list.add(new Sales (apiData[i]['genre'], apiData[i]['sales'], apiData[i]['donate'],));
  }

  return [
        new charts.Series<Sales, String>(
          id: 'Product Sales',
          data: list,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => int.parse(sales.totsales),
          colorFn: (Sales sales, _) => charts.MaterialPalette.blue.shadeDefault
        ),

        new charts.Series<Sales, String>(
          id: 'Collected Donation',
          data: list,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => int.parse(sales.donate),
          colorFn: (Sales sales, _) => charts.MaterialPalette.red.shadeDefault
        ),

      ]; 
  
}

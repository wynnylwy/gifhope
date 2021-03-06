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
  List <dynamic>salesData;

  @override
  // void initState() {
  //   super.initState();
  //   seriesBarData = getData();
  // }

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
                if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasError == false)
                {
                  return Center(
                    child: CircularProgressIndicator()
                  );
                }

                else 
                {
                  return new charts.BarChart(
                    dataList (salesData),
                    vertical: true,
                    animate: true,
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
    await http.get(urlLoadJobs).then((res) {
      print(res.body);

      if (res.body.contains("nodata")) {
        setState(() {
          salesData = null;
        });
      } else {
        setState(() {
          // Iterable mapData = json.decode(res.body);
          // List<Sales> list = mapData.toList();
          // return list;

        Map<String, dynamic> map = json.decode(res.body);
        map.forEach((k,v) => salesData.add(Sales(k,v)));
        print(salesData);
        //salesData = map["sales"].toList();
          
        });
      }

      return salesData;

    }).catchError((err) {
      print(err);
    });
  }

}

List<charts.Series<Sales, String>> dataList(List<dynamic> apiData) 
{
  List<Sales> list = new List();

  for (int i=0; i< apiData.length; i++)
  {
  
    list.add(new Sales (apiData[i]['genre'], apiData[i]['sales']));
  }

  return [
        new charts.Series<Sales, String>(
          id: 'Sales',
          data: list,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => int.parse(sales.totsales),
        ),

      ]; 
  
}

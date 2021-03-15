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
  List<String> listMonth = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  String selectedMonth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFF3366FF),
                  const Color(0xFF00CCFF),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('Sales Report',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Container(
        // color: Colors.blue[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
          Padding(
            padding: EdgeInsets.fromLTRB(150, 10, 5, 50),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              color: Colors.red,
              child: Row(
                children: [
                  Text("Month Selected: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        )),
                  SizedBox(width: 25),
                  DropdownButton(
                      hint: Text("Month"),
                      value: selectedMonth,
                      items: listMonth.map((selectedMonth) {
                        return DropdownMenuItem(
                            child: new Text(
                              selectedMonth,
                              textAlign: TextAlign.center,
                            ),
                            value: selectedMonth);
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = newValue;
                          print(selectedMonth);
                          postMonthSelected(selectedMonth);
                        });
                      }),
                ],
              ),
            ),
          ),

          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "RM",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              )),
          ),

          selectedMonth == null 
          ? Container(
            color: Colors.red,
          )
          :
          Container(
            color: Colors.yellow,
            height: MediaQuery.of(context).size.height * 0.60,
            child: FutureBuilder(
                future: getData(selectedMonth),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.hasData == false) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return new charts.BarChart(
                      dataList(snapshot.data),
                      vertical: true,
                      animate: true,
                      barGroupingType: charts.BarGroupingType.grouped,
                      behaviors: [
                        new charts.SeriesLegend(
                          position: charts.BehaviorPosition.bottom,
                          horizontalFirst: false, //legend show vertically
                        )
                      ],
                      animationDuration: Duration(
                        microseconds: 2000,
                      ),
                    );
                  }
                }),
          ),
        ]),
      ),
    );
  }

  Future getData(String selectedMonth) async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesReport.php";
    final res = await http.post(urlLoadJobs, body: {

      "selectedMonth" : selectedMonth,
    });

    if (res.body.contains("nodata")) {
      return false;
    } 
    
    else {
      // Map<String, dynamic> map =
      //     json.decode(res.body); //json decode will return dynamic
      // final List<dynamic> salesData = map["sales"].toList();

      

      
         Map<String, dynamic> map =  json.decode(res.body);
           final List<dynamic> salesData = map["sales"].toList();
        return salesData;

      
    }
  }

  List<charts.Series<Sales, String>> dataList(List<dynamic> apiData) {
  List<Sales> list = new List();

  for (int i = 0; i < apiData.length; i++) {
    list.add(new Sales(
      apiData[i]['genre'],
      apiData[i]['sales'],
      apiData[i]['donate'],
    ));
  }

  return [
    new charts.Series<Sales, String>(
        id: 'Product Sales',
        data: list,
        domainFn: (Sales sales, _) => sales.genre,
        measureFn: (Sales sales, _) => int.parse(sales.totsales),
        colorFn: (Sales sales, _) => charts.MaterialPalette.blue.shadeDefault),
    new charts.Series<Sales, String>(
        id: 'Collected Donation',
        data: list,
        domainFn: (Sales sales, _) => sales.genre,
        measureFn: (Sales sales, _) => int.parse(sales.donate),
        colorFn: (Sales sales, _) => charts.MaterialPalette.red.shadeDefault),
  ];
}


  Future postMonthSelected(String monthSelected) async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/get_monthSelected.php";
    await http.post(urlLoadJobs, body: {

      "monthSelected" : monthSelected,
    }).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);
       
        setState(() {
          seriesBarData = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          seriesBarData = extractdata["month"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}



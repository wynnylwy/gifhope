import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'sales.dart';

class SalesReportScreen extends StatefulWidget {
  SalesReportScreen({Key key}) : super(key: key);

  @override
  _SalesReportScreenState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  List<dynamic> salesData;
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
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  const Color(0xFFFDD835),
                  const Color(0xFFFBC02D),
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
                color: Colors.black)),
      ),
      body: Container(
        color: Colors.amber[100],
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(150, 10, 5, 5),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              // color: Colors.red,
              child: Row(
                children: [
                  Text("Month Selected: ",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                        });
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(220, 5, 10, 5),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.025,
                  width: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  "Product Sales",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.025,
                  width: MediaQuery.of(context).size.width * 0.06,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  "Collected Donation",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ]),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("RM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                )),
          ),
          selectedMonth == null && salesData == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width * 0.55,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/images/exclam.png'),
                        ))),
                    Container(
                      child: Shimmer.fromColors(
                          baseColor: Colors.black87,
                          highlightColor: Colors.grey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "No Records",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Mogra',
                                      fontSize: 38.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Please select month",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Mogra',
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                    ),
                  ],
                )
              : Container(
                  //color: Colors.yellow,
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: FutureBuilder(
                      future: getData(selectedMonth),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.hasData == false) {
                          return Center(child: CircularProgressIndicator());
                        } 
                        else if (snapshot.hasData == true &&
                            snapshot.data == false) {
                          return Column(
                            children: [
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    fit: BoxFit.fitWidth,
                                    image: AssetImage('assets/images/sad.png'),
                                  ))),
                              Container(
                                child: Shimmer.fromColors(
                                    baseColor: Colors.black87,
                                    highlightColor: Colors.grey,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            "No Records",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mogra',
                                                fontSize: 38.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Please re-select month",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mogra',
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ])),
                              ),
                            ],
                          );
                        } 
                        else {
                          return new charts.BarChart(
                            dataList(snapshot.data),
                            vertical: true,
                            animate: true,
                            barGroupingType: charts.BarGroupingType.grouped,
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
      "selectedMonth": selectedMonth,
    });

    if (res.body.contains("nodata")) {
      return false;
    } else {
      Map<String, dynamic> map =
          json.decode(res.body); //json decode will return dynamic
      salesData = map["sales"].toList();

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
          colorFn: (Sales sales, _) =>
              charts.MaterialPalette.blue.shadeDefault),
      new charts.Series<Sales, String>(
          id: 'Collected Donation',
          data: list,
          domainFn: (Sales sales, _) => sales.genre,
          measureFn: (Sales sales, _) => int.parse(sales.donate),
          colorFn: (Sales sales, _) => charts.MaterialPalette.red.shadeDefault),
    ];
  }
}

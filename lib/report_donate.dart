import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'cdonate.dart';

class DonateReportScreen extends StatefulWidget {
  DonateReportScreen({Key key}) : super(key: key);

  @override
  _DonateReportScreenState createState() => _DonateReportScreenState();
}

class _DonateReportScreenState extends State<DonateReportScreen> {
  List<dynamic> donateData;

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
        title: Text('Donation Report',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(150, 10, 5, 10),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
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
            child: Row(children: <Widget>[
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
              )
            ]),
          ),
          SizedBox(height:20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("RM",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                )),
          ),
          selectedMonth == null && donateData == null
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Center(
                      child: Shimmer.fromColors(
                          baseColor: Colors.black87,
                          highlightColor: Colors.amber[800],
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              ]))),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: FutureBuilder(
                      future: getData(selectedMonth),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.none ||
                            snapshot.hasData == false) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasData == true &&
                            snapshot.data == false) {
                          return Container(
                            child: Center(
                                child: Shimmer.fromColors(
                                    baseColor: Colors.black87,
                                    highlightColor: Colors.amber[800],
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                            "Please reselect month",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Mogra',
                                                fontSize: 30.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]))),
                          );
                        } else {
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
        "https://yitengsze.com/a_gifhope/php/load_donationReport.php";
    final res = await http.post(urlLoadJobs, body: {
      "selectedMonth": selectedMonth,
    });

    if (res.body.contains("nodata")) {
      return false;
    } else {
      Map<String, dynamic> map =
          json.decode(res.body); //json decode will return dynamic
      donateData = map["donate"].toList();

      return donateData;
    }
  }
}

List<charts.Series<CDonate, String>> dataList(List<dynamic> apiData) {
  List<CDonate> list = new List();

  for (int i = 0; i < apiData.length; i++) {
    list.add(new CDonate(apiData[i]['genre'], apiData[i]['donate']));
  }

  return [
    new charts.Series<CDonate, String>(
        id: 'Collected Donation',
        data: list,
        domainFn: (CDonate donate, _) => donate.genre,
        measureFn: (CDonate donate, _) => int.parse(donate.donate),
        colorFn: (CDonate donate, _) =>
            charts.MaterialPalette.red.shadeDefault),
  ];
}

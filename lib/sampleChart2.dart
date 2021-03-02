import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}
  
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List data;
  Timer timer;

  makeRequest() async {
    var response = await http.get(
      'http://localhost/werkzeug/public/api/data_tool1',
      headers: {'Accept': 'application/json'},
    );

    setState(() {
      data = json.decode(response.body);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = new Timer.periodic(new Duration(seconds: 2), (t) => makeRequest());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Tool Data'),
      ),
      body: data == null ? CircularProgressIndicator() : createChart(),
    );
  }

  charts.Series<LiveWerkzeuge, String> createSeries(String id, int i) {
    return charts.Series<LiveWerkzeuge, String>(
      id: id,
      domainFn: (LiveWerkzeuge wear, _) => wear.wsp,
      measureFn: (LiveWerkzeuge wear, _) => wear.belastung,
      // data is a List<LiveWerkzeuge> - extract the information from data
      // could use i as index - there isn't enough information in the question
      // map from 'data' to the series
      // this is a guess
      data: [
        LiveWerkzeuge('WSP1', data[i]['temp1']),
        LiveWerkzeuge('WSP2', data[i]['temp2']),
        LiveWerkzeuge('WSP3', data[i]['temp3']),
        LiveWerkzeuge('WSP4', data[i]['temp4']),
        LiveWerkzeuge('WSP5', data[i]['temp5']),
        LiveWerkzeuge('WSP6', data[i]['temp6']),
        LiveWerkzeuge('WSP7', data[i]['temp7']),
        LiveWerkzeuge('WSP8', data[i]['temp8']),
      ],
    );
  }

  Widget createChart() {
    // data is a List of Maps
    // each map contains at least temp1 (tool 1) and temp2 (tool 2)
    // what are the groupings?

    List<charts.Series<LiveWerkzeuge, String>> seriesList = [];

    for (int i = 0; i < data.length; i++) {
      String id = 'WZG${i + 1}';
      seriesList.add(createSeries(id, i));
    }

    return new charts.BarChart(
      seriesList,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}

class LiveWerkzeuge {
  final String wsp;
  final int belastung;

  LiveWerkzeuge(this.wsp, this.belastung);
}
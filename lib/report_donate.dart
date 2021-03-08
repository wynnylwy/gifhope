import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

import 'cdonate.dart';

class DonateReportScreen extends StatefulWidget {
  DonateReportScreen({Key key}) : super(key: key);

  @override
  _DonateReportScreenState createState() => _DonateReportScreenState();
}

class _DonateReportScreenState extends State<DonateReportScreen> {
  List<charts.Series<CDonate, String>> seriesBarData;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation Report"),
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
                      position: charts.BehaviorPosition.bottom,
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
        "https://yitengsze.com/a_gifhope/php/load_donateReport.php";
    final res = await http.get(urlLoadJobs);

      if (res.body.contains("nodata")) 
      {
        return false;
      } 
      
      else 
      {
        Map<String, dynamic> map = json.decode(res.body);  //json decode will return dynamic
        final List<dynamic> donateData = map["donate"].toList();

        return donateData;
      }
    }
}

List<charts.Series<CDonate, String>> dataList(List<dynamic> apiData) 
{
  List<CDonate> list = new List();

  for (int i=0; i< apiData.length; i++)
  {
  
    list.add(new CDonate (apiData[i]['genre'], apiData[i]['donate']));
  }

  return [
        

        new charts.Series<CDonate, String>(
          id: 'Collected Donation',
          data: list,
          domainFn: (CDonate donate, _) => donate.genre,
          measureFn: (CDonate donate, _) => int.parse(donate.donate),
          colorFn: (CDonate donate, _) => charts.MaterialPalette.red.shadeDefault
        ),

      ]; 
  
}

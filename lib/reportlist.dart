import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class ReportList extends StatefulWidget {
  ReportList({Key key}) : super(key: key);

  @override
  ReportListState createState() => ReportListState();
}

class ReportListState extends State<ReportList> {
  List carsdata;
  double screenHeight, screenWidth;
  String titlecenter = "Cars data is not found";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
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
        title: Text('Sold  List',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Center(
        child: Container(
          color: Colors.blue[100],
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10)),
              carsdata == null
                  ? Flexible(
                      child: Container(
                          child: Center(
                      child: Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey,
                          child: Text(
                            titlecenter,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Mogra',
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          )),
                    )))
                  : Expanded(
                      child: ListView.builder(
                          itemCount: carsdata == null ? 0 : carsdata.length,
                            itemBuilder: (context, index) {
                            return Padding(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 1),
                                child: InkResponse(
                                  focusColor: Colors.blue[300],
                                  hoverColor: Colors.blue[300],
                                  highlightColor: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Card(
                                    
                                    elevation: 10,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child:
                                              Text((index + 1).toString() + ".",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              
                                              Text(carsdata[index]['id'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(carsdata[index]['name'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text("Sold: ",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  )),
                                              Text(carsdata[index]['sold'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          }),
                       
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _loadData() async {
    String urlLoadJobs = "https://yitengsze.com/carVroom/php/load_cars.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        titlecenter = "No product found";
        setState(() {
          carsdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          carsdata = extractdata["cars"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}

import 'package:flutter/material.dart';
import 'package:gifhope/collectdonation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';


import 'order.dart';
import 'package:gifhope/purchasedetailscreen.dart';

import 'salesdonate.dart';

class CollectDonationTileScreen extends StatefulWidget {


  const CollectDonationTileScreen({Key key}) : super(key: key);

  @override
  _CollectDonationTileScreenState createState() => _CollectDonationTileScreenState();
}

class _CollectDonationTileScreenState extends State<CollectDonationTileScreen> {
  List salesdetails;

  String titlecenter = "Loading collect donation...";
  final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

  void initState() {
    super.initState();
    _loadSalesTile();
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
                  const Color(0xFFFF8A65),
                  const Color(0xFFFFCA28),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('Collect Donation',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Center(
        child: Container(
          color: Colors.orange[100],
          child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10)
            ),
            salesdetails == null
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
                        itemCount: salesdetails == null ? 0 : salesdetails.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
                              child: InkResponse( 
                                focusColor: Colors.blue[300],
                                hoverColor: Colors.blue[300],
                                highlightColor: Colors.blue[300],
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () => setState(() {

                                  loadSalesDetails(index);  //
                                }),
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
                                                  fontWeight: FontWeight.bold,
                                                )),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Genre: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Text(salesdetails[index]['genre']),
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //   flex: 4,
                                      //   child: Column(
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.center,
                                      //     children: <Widget>[
                                      //       Text(
                                      //         "RM " +
                                      //             salesdetails[index]['sales'],
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Column(
                                              children: <Widget>[
                                                Text("Total Sales (RM): ",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(salesdetails[index]
                                                    ['sales']),
                                              ],
                                            ),
                                            
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

  _loadSalesTile() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesDonation.php";

    await http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          salesdetails = null;
          titlecenter = "No Sales Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          salesdetails = extractdata["sales"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadSalesDetails(int index) {
    SalesDonate salesDonate = new SalesDonate(
      sellerid: salesdetails[index]['sellerid'],
      genre: salesdetails[index]['genre'],
      sales: salesdetails[index]['sales'],
      donate: salesdetails[index]['donate'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CollectDonationScreen(
                 
                  collect: salesDonate,
                )));
  }
}

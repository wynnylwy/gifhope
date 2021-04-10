import 'package:flutter/material.dart';
import 'package:gifhope/collectdonation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'salesdonate.dart';
import 'user.dart';

class CollectDonationTileScreen extends StatefulWidget {
  final User user;
  const CollectDonationTileScreen({Key key, this.user}) : super(key: key);

  @override
  _CollectDonationTileScreenState createState() =>
      _CollectDonationTileScreenState();
}

class _CollectDonationTileScreenState extends State<CollectDonationTileScreen> {
  List salesdetails;
  String titlecenter = "Loading collect donation...";
  final dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  GlobalKey<RefreshIndicatorState> refreshKey;

  void initState() {
    super.initState();
    _loadSalesTile();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
        title: Text('Collect Donation',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        color: Colors.red,
        strokeWidth: 3,
        onRefresh: () async {
          await refreshList();
        },
        child: Center(
          child: Container(
            color: Colors.amber[100],
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40, width: 16,),
                    Expanded(
                      flex: 10,
                      child: RichText(
                        text: TextSpan(
                          text: "No.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.black
                          )
                        ),
                        ),
                    ),
                    Expanded(
                      flex: 12,
                      child: RichText(
                        text: TextSpan(
                          text: "Genre",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.black
                          )
                        ),
                        ),
                    ),

                    Expanded(
                      flex: 14,
                      child: RichText(
                        text: TextSpan(
                          text: "Total Sales (RM)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.black
                          )
                        ),
                        ),
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(10)),
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
                            itemCount:
                                salesdetails == null ? 0 : salesdetails.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                  child: InkResponse(
                                    focusColor: Colors.blue[300],
                                    hoverColor: Colors.blue[300],
                                    highlightColor: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () => setState(() {
                                      loadSalesDetails(index); //
                                    }),
                                    child: Container(
                                      height: 60,
                                      color: Colors.red,
                                      child: Card(
                                        elevation: 25,
                                        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                        child: Container(
                                          
                                          color: Colors.yellow[100],
                                            child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                    (index + 1).toString() + ".",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    )),
                                              ),

                                              Expanded(
                                                flex: 8,
                                                child: Text( 
                                                  salesdetails[index]['genre'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                        fontSize: 20,
                                                      
                                                    )),
                                              ),

                                              Expanded(
                                                flex: 4,
                                                child: Text( 
                                                  salesdetails[index]['sales'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                        fontSize: 20,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                            }),
                      ),
              ],
            ),
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
      genre: salesdetails[index]['genre'],
      sales: salesdetails[index]['sales'],
      donate: salesdetails[index]['donate'],
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => CollectDonationScreen(
                  collect: salesDonate,
                  user: widget.user,
                )));

    _loadSalesTile();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds:1));
    _loadSalesTile();
    return null;
  }

}

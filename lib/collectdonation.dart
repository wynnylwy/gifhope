import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:shimmer/shimmer.dart';
import 'package:share/share.dart';

import 'salesdonate.dart';
import 'user.dart';

class CollectDonationScreen extends StatefulWidget {
  final SalesDonate collect;
  final User user;

  const CollectDonationScreen({Key key, this.collect, this.user}) : super(key: key);

  @override
  _CollectDonationScreenState createState() => _CollectDonationScreenState();
}

class _CollectDonationScreenState extends State<CollectDonationScreen> {
  
  User user; 
  List salesdetails;
  List sellerInfo;
  String titlecenter = "Loading collect donation...";
  double screenHeight, screenWidth;
  int quantity = 1;
  String purchasequantity = "0";
  String beforeText = "(before collect donation)";
  String beforeText2 = "(before collect donation)";
  String afterText = "(after collect donation)";

  bool isTransparent = true;
  bool calcDonationText = true;
  bool collectDonationText = true;
  bool sendDonationReceiptText = true;

  void initState() {
    super.initState();
    user = widget.user;
    _loadSalesDetails();
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
      body: Container(
        color: Colors.amber[100],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
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
                              color: Colors.white,
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
                          return Container(
                            //color: Colors.red,
                            height: screenHeight / 2.5, //height between card
                            width: screenWidth / 2.5,
                            child: Column(
                              children: <Widget>[
                                Card(
                                    elevation: 10,
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(28, 10, 10, 10),
                                        child: Row(children: <Widget>[
                                          Flexible(
                                            fit: FlexFit.tight,
                                            child: Container(
                                                // color: Colors.yellow,
                                                width: screenWidth / 3,
                                                height: screenHeight / 3,
                                                child: Row(
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Column(
                                                        children: <Widget>[
                                                          
                                                          SizedBox(height: 3),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Genre: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                salesdetails[
                                                                        index]
                                                                    ['genre'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 15),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Total sales: RM ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                salesdetails[
                                                                        index]
                                                                    ['sales'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        25),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 2),
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              beforeText,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Opacity(
                                                            opacity:
                                                                isTransparent
                                                                    ? 0
                                                                    : 1,
                                                            child: Container(
                                                              height: screenHeight / 10,
                                                              width: screenWidth,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment.end,
                                                                children: [
                                                                  Align(
                                                                    alignment:
                                                                        Alignment.centerRight,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                            "Total Donation: ",
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                        Text(
                                                                            "(20%)",
                                                                            style: TextStyle(fontSize: 16.0)),
                                                                        Text("RM " + salesdetails[index]['donate'],
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.red,
                                                                                fontSize: 25.0)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: <Widget>[
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0)),
                                                                minWidth: 100,
                                                                height: 40,
                                                                child: (calcDonationText)
                                                                    ? Text('Calculate Donation',
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                        ))
                                                                    : (collectDonationText)
                                                                        ? Text('Collect Donation',
                                                                            style: TextStyle(
                                                                              fontSize: 18.0,
                                                                            ))
                                                                        : (sendDonationReceiptText)
                                                                            ? Text('Send Donation Receipt',
                                                                                style: TextStyle(
                                                                                  fontSize: 18.0,
                                                                                ))
                                                                            : null,
                                                                color: Colors.blue[500],
                                                                textColor: Colors.white,
                                                                elevation: 10,
                                                                onPressed: () =>
                                                                    {
                                                                  setState(() {
                                                                    isTransparent = !isTransparent;

                                                                    if (calcDonationText == true) //pressed calc
                                                                    { 
                                                                      calcDonationText = false;
                                                                      collectDonationText = true;
                                                                      sendDonationReceiptText = false;
                                                                    } 
                                                                    else if (collectDonationText == true) //pressed collect
                                                                    {
                                                                      calcDonationText = false;
                                                                      collectDonationText = false;
                                                                      beforeText = afterText;

                                                                      showCollectDialog(index);
                                                                      sendDonationReceiptText = true;
                                                                    } 
                                                                    else   //pressed send
                                                                    {
                                                                      calcDonationText = true;
                                                                      collectDonationText = false;
                                                                      sendDonationReceiptText = false;

                                                                      beforeText = beforeText2;

                                                                      String genreReceipt = salesdetails[index]['genre'];
                                                                      String donateValue = salesdetails[index]['donate'];
                                                                      goToShare(user, genreReceipt,donateValue);
                                                                    }
                                                                  }),
                                                                },
                                                              ),
                                                              MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0)),
                                                                minWidth: 100,
                                                                height: 40,
                                                                child: Text(
                                                                    'Back',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18.0,
                                                                    )),
                                                                color: Colors
                                                                    .blue[500],
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 10,
                                                                onPressed: () {
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ),
                                        ])))
                              ],
                            ),
                          );
                        }),
                  ),
          ],
        ),
      ),
    );
  }

  _loadSalesDetails() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_salesDonationDetails.php";

    await http.post(urlLoadJobs, body: {
      "genre": widget.collect.genre,
    }).then((res) {
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

   showCollectDialog(int index) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Collect from " + salesdetails[index]['genre'],
                style: TextStyle(
                  fontFamily: 'Bellota',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Yes",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                    collectDonation(index);
                  },
                ),
                MaterialButton(
                  child: Text("Cancel",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          });
        });
  }

  collectDonation(int index) {
    try {
      String genre = salesdetails[index]["genre"];
      double sales = double.parse(salesdetails[index]["sales"]);
      double donate = double.parse(salesdetails[index]["donate"]);
      print("Genre: " + genre);
      print("Sales: " + sales.toString());
      print("Donate: " + donate.toString());

      if (donate > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);

        pr.style(message: "Collecting...");
        pr.show();

        String urlLoadJobs =
            "https://yitengsze.com/a_gifhope/php/update_salesDonation.php";
        http.post(urlLoadJobs, body: {
          "genre": salesdetails[index]['genre'],
          "sales": salesdetails[index]['sales'],
          "donate": salesdetails[index]['donate'],
        }).then((res) {
          print(res.body);
          if (res.body.contains("failed")) {
            Toast.show("Collection Failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } else {
            List respond = res.body.split(",");
            setState(() {
              purchasequantity = respond[1];
              _loadSalesDetails();
            });

            Toast.show("Collection Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });

        pr.hide();
      } else {
        Toast.show("Not enough amount to collect", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Collection Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future<void> goToShare (User user, String genreReceipt, String donateValue){

      if (donateValue != '0' || donateValue != null){
        share(context, user, genreReceipt, donateValue);
      }
      else{
        print("Error");
      }
  }

  Future<void> share(BuildContext context, User user, String genreReceipt, String donateValue) async {
    
    final RenderBox box = context.findRenderObject();

    final String text1 = "Donation Success";
    final String text2 = " Your sales have been deducted for 20% sucessfully as the donation to Gifhope! \nEvents you donated to: \n Genre: $genreReceipt \n Amount: RM $donateValue \n\n For inquiries, you may contact: \n Name: ${widget.user.name} \n Contact: ${widget.user.phone} \n Email: ${widget.user.email} \n\n THANK YOU! ";
    await Share.share(
      text2,
      subject: text1,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}

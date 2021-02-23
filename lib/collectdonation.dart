import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'product.dart';
import 'user.dart';
import 'purchasescreen.dart';

class CollectDonationScreen extends StatefulWidget {
  final User user;
  final Product product;

  const CollectDonationScreen({Key key, this.user, this.product})
      : super(key: key);

  @override
  _CollectDonationScreenState createState() => _CollectDonationScreenState();
}

class _CollectDonationScreenState extends State<CollectDonationScreen> {
  List salesdetails;
  String titlecenter = "Loading collect donation...";
  double screenHeight, screenWidth;
  int quantity = 1;
  String purchasequantity = "0";
  bool isTransparent = true;

  void initState() {
    super.initState();
    _loadSalesDetails();
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
        title: Text('Collect Donation ',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Container(
        color: Colors.blue[800],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            salesdetails == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.yellow[200],
                        highlightColor: Colors.white,
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Seller ID: ",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                              Text(
                                                                salesdetails[
                                                                        index][
                                                                    'sellerid'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ],
                                                          ),
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
                                                                        index][
                                                                    'sales'],
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
                                                              "(before collect donation)",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),

                                                         
                                                           Opacity(
                                                             opacity: isTransparent ? 0 : 1, 
                                                                                                                        child: Container(  //put it in setState
                                                                height: screenHeight/ 10,
                                                                width: screenWidth,
                                                                color: Colors.yellow,
                                                                child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Align(
                                                                    alignment: Alignment
                                                                        .centerRight,
                                                                    child: Column(
                                                                      children: [
                                                                        Text(
                                                                            "Total Donation: ",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    16.0)),
                                                                        Text(
                                                                            "(20%)",
                                                                            style: TextStyle(
                                                                                fontSize:
                                                                                    16.0)),
                                                                        Text(
                                                                            "RM " +
                                                                                salesdetails[index][
                                                                                    'sales'],
                                                                            style: TextStyle(
                                                                                fontWeight:
                                                                                    FontWeight.bold,
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
                                                                child: Text(
                                                                    'Calculate Donation',
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
                                                                onPressed: () =>
                                                                    {
                                                                 setState(()=> isTransparent = !isTransparent),
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
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
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
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_salesdonation.php";

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

  // Future<void> buyAgain(int index) async {
  //   quantity = 1;

  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, newSetState) {
  //           return AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //             title: new Text(
  //               "Purchase for " + purchasedetails[index]['name'],
  //               style: TextStyle(
  //                 fontFamily: 'Bellota',
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.black,
  //               ),
  //             ),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(
  //                   "Select purchase quantity:",
  //                   style: TextStyle(color: Colors.black),
  //                 ),
  //                 //Row select qtty
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     FlatButton(
  //                       onPressed: () => {
  //                         newSetState(() {
  //                           if (quantity > 1) {
  //                             quantity--;
  //                           }
  //                         })
  //                       },
  //                       child: Icon(MdiIcons.minus, color: Colors.blue[400]),
  //                     ),
  //                     Text(quantity.toString(),
  //                         style: TextStyle(color: Colors.black)),
  //                     FlatButton(
  //                       onPressed: () => {
  //                         newSetState(() {
  //                           if (quantity <
  //                               (int.parse(purchasedetails[index]['quantity']) -
  //                                   2)) {
  //                             quantity++;
  //                           } else {
  //                             Toast.show(
  //                                 "Product's quantity is not available", context,
  //                                 duration: Toast.LENGTH_LONG,
  //                                 gravity: Toast.BOTTOM);
  //                           }
  //                         })
  //                       },
  //                       child: Icon(MdiIcons.plus, color: Colors.blue[400]),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             actions: <Widget>[
  //               MaterialButton(
  //                 child: Text("Yes",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                     )),
  //                 onPressed: () {
  //                   addToPurchaseAgain(index);
  //                   //get id's data, then pass, then push to page
  //                 },
  //               ),
  //               MaterialButton(
  //                 child: Text("Cancel",
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                     )),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(false);
  //                 },
  //               ),
  //             ],
  //           );
  //         });
  //       });
  // }

  // addToPurchaseAgain(int index) {
  //   try {
  //     var id = purchasedetails[index]["id"];
  //     int cquantity = int.parse(purchasedetails[index]["quantity"]); //current available qty
  //     print(cquantity);
  //     print(id);
  //     print(widget.user.email);

  //     if (cquantity > 0) {
  //       ProgressDialog pr = new ProgressDialog(context,
  //           type: ProgressDialogType.Normal, isDismissible: false);

  //       pr.style(message: "Add to Purchase...");
  //       pr.show();

  //       String urlLoadJobs =
  //           "https://yitengsze.com/a_gifhope/php/insert_purchase.php";
  //       http.post(urlLoadJobs, body: {
  //         "email": widget.user.email,
  //         "proid": purchasedetails[index]['id'],
  //         "quantity": quantity.toString(),
  //       }).then((res) {
  //         print(res.body);
  //         if (res.body.contains("failed")) {
  //           Toast.show("Purchase Failed", context,
  //               duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //         }

  //         else {
  //           List respond = res.body.split(",");
  //           setState(() {
  //             purchasequantity = respond[1];
  //             widget.user.quantity = purchasequantity;
  //           });
  //           Toast.show("Purchase Success", context,
  //               duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (BuildContext context) => PurchaseScreen(
  //                         user: widget.user,
  //                         id: purchasedetails[index]['id'],
  //                       )));
  //         }
  //         pr.hide();
  //       }).catchError((err) {
  //         print(err);
  //         pr.hide();
  //       });

  //       pr.hide();
  //     } else {
  //       Toast.show("Out of stock", context,
  //           duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //     }
  //   } catch (e) {
  //     Toast.show("Purchase Failed", context,
  //         duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //   }

  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (BuildContext context) => PurchaseScreen(
  //                 user: widget.user,
  //                 id: purchasedetails[index]['id'],
  //               )));
  // }
}

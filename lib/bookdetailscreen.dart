import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'order.dart';
import 'user.dart';
import 'purchasescreen.dart';

class BookDetailScreen extends StatefulWidget {
  final Order book;
  final User user;

  const BookDetailScreen({Key key, this.book, this.user}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  List purchasedetails;
  String titlecenter = "Loading purchase details...";
  double screenHeight, screenWidth;
  int quantity = 1;
  String purchasequantity = "0";

  void initState() {
    super.initState();
    _loadBookDetails();
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
        title: Text('Purchase Details',
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
            purchasedetails == null
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
                        itemCount: purchasedetails == null ? 0 : purchasedetails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: screenHeight / 2.2,
                            width: screenWidth / 2.5,
                            child: Column(
                              children: <Widget>[
                                Card(
                                    elevation: 10,
                                    margin: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  //Pic's
                                                  height: screenWidth / 3.0,
                                                  width: screenWidth / 4.6,
                                                  child: ClipOval(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.scaleDown,
                                                    imageUrl:
                                                        "http://yitengsze.com/a_gifhope/productimages/${purchasedetails[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ))),
                                            ],
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 1, 10, 1),
                                              child: SizedBox(
                                                  width: 3,
                                                  child: Container(
                                                    height: screenWidth / 1.5,
                                                    color: Colors.grey,
                                                  ))),
                                          Container(
                                              width: screenWidth / 1.6,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            purchasedetails[index]
                                                                ['name'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 18),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                        SizedBox(height: 15),
                                                        Row(children: <Widget>[
                                                          Text(
                                                            "Genre: ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0),
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                              purchasedetails[index]
                                                                  ['genre'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0)),
                                                          Spacer(flex: 2),

                                                          Icon(MdiIcons.currencyUsd),
                                                          Text(
                                                              "RM " +
                                                                  purchasedetails[
                                                                          index]
                                                                      ['price'],
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      16.0)),
                                                        ]),
                                                        SizedBox(height: 5),
                                                        Row(children: <Widget>[
                                                          Text(
                                                            "Quantity: ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16.0),
                                                            maxLines: 1,
                                                          ),
                                                          Text(
                                                              purchasedetails[index]
                                                                  ['cquantity'],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0)),
                                                        ]),
                                                        SizedBox(height: 20),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              Text(
                                                                "Purchase Total: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0),
                                                                maxLines: 1,
                                                              ),
                                                              Text(
                                                                "(after discount)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0),
                                                                maxLines: 1,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                      Icons
                                                                          .payment,
                                                                      color: Colors
                                                                          .red),
                                                                  Text(
                                                                      " RM " +
                                                                          purchasedetails[index]
                                                                              [
                                                                              'total'],
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20.0)),
                                                                ],
                                                              ),
                                                            ]),
                                                        SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0)),
                                                              minWidth: 100,
                                                              height: 35,
                                                              child: Text(
                                                                  'Buy again',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                  )),
                                                              color: Colors
                                                                  .blue[500],
                                                              textColor:
                                                                  Colors.white,
                                                              elevation: 10,
                                                              onPressed: () => {
                                                                buyAgain(index)
                                                              },
                                                            ),
                                                            MaterialButton(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                                  Colors.white,
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

  _loadBookDetails() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_purchaseHistory.php"; 

    await http.post(urlLoadJobs, body: {
      "orderid": widget.book.orderid,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          purchasedetails = null;
          titlecenter = "No Purchase Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          purchasedetails = extractdata["purchase"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> buyAgain(int index) async {
    quantity = 1;

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Purchase for " + purchasedetails[index]['name'],
                style: TextStyle(
                  fontFamily: 'Bellota',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select purchase quantity:",
                    style: TextStyle(color: Colors.black),
                  ),
                  //Row select qtty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {
                          newSetState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          })
                        },
                        child: Icon(MdiIcons.minus, color: Colors.blue[400]),
                      ),
                      Text(quantity.toString(),
                          style: TextStyle(color: Colors.black)),
                      FlatButton(
                        onPressed: () => {
                          newSetState(() {
                            if (quantity <
                                (int.parse(purchasedetails[index]['quantity']) -
                                    2)) {
                              quantity++;
                            } else {
                              Toast.show(
                                  "Product's quantity is not available", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                          })
                        },
                        child: Icon(MdiIcons.plus, color: Colors.blue[400]),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Yes",
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  onPressed: () {
                    addToPurchaseAgain(index);
                    //get id's data, then pass, then push to page
                  },
                ),
                MaterialButton(
                  child: Text("Cancel",
                      style: TextStyle(
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

  addToPurchaseAgain(int index) {
    try {
      var id = purchasedetails[index]["id"];
      int cquantity = int.parse(purchasedetails[index]["quantity"]); //current available qty
      print(cquantity);
      print(id);
      print(widget.user.email);

      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);

        pr.style(message: "Add to Purchase...");
        pr.show();

        String urlLoadJobs =
            "https://yitengsze.com/a_gifhope/php/insert_purchase.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": purchasedetails[index]['id'],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body.contains("failed")) {
            Toast.show("Purchase Failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } 
          
          else {
            List respond = res.body.split(",");
            setState(() {
              purchasequantity = respond[1];
              widget.user.quantity = purchasequantity;
            });
            Toast.show("Purchase Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PurchaseScreen(
                          user: widget.user,
                          id: purchasedetails[index]['id'],
                        )));
          }
          pr.hide();
        }).catchError((err) {
          print(err);
          pr.hide();
        });

        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Purchase Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PurchaseScreen(
                  user: widget.user,
                  id: purchasedetails[index]['id'],
                )));
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gifhope/product.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:gifhope/user.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'product.dart';

class DetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final User user;

  DetailsScreen({Key key, this.product, this.user}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List productdata;
 // Map index = widget.product.key;
  

  String titlecenter = "Product data is not found";
  int numOfItem = 1;
  String datalink = "https://yitengsze.com/a_gifhope/php/load_product.php";
  String insertlink ="https://yitengsze.com/a_gifhope/php/insert_purchase.php";

  @override
  void initState() {
    super.initState();
    _loadProductData();
  }

  Widget build(BuildContext context) {
    //int index = this.product[index];
    
    Size size = MediaQuery.of(context).size;
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
          title: Text('Details Screen',
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: size.height,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.3),
                      padding: EdgeInsets.only(top: size.height * 0.12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                            child: Text(
                              widget.product["description"],
                              textAlign: TextAlign.justify,
                              style: TextStyle(height: 1.8, fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                buildOutlineButton(
                                  icon: Icons.remove,
                                  press: () {
                                    if (numOfItem > 1) {
                                      setState(() {
                                        numOfItem--;
                                      });
                                    }
                                  },
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Text(
                                    // if our item is less  then 10 then  it shows 01 02 like that
                                    numOfItem.toString().padLeft(2, "0"),
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                buildOutlineButton(
                                    icon: Icons.add,
                                    press: () {
                                      setState(() {
                                        numOfItem++;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18)),
                                      color: Colors.yellow[300],
                                      onPressed: () {
                                        setState(() {
                                         
                                         _addToPurchase(numOfItem);
                                        });
                                        Navigator.of(context).pop(false);

                                      },
                                      child: Text(
                                        "Add to purchase".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    productdata == null
                        ? Flexible(
                            child: Container(
                                color: Colors.blue[800],
                                child: Center(
                                  child: Shimmer.fromColors(
                                      baseColor: Colors.yellow[500],
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
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.product["genre"],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    widget.product["name"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: <Widget>[
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Price: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                            TextSpan(
                                              text:
                                                  "\$${widget.product["price"]}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Hero(
                                          tag: "${widget.product["pid"]}",
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "http://yitengsze.com/a_gifhope/productimages/${widget.product["id"]}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  _loadProductData() async {
    String urlLoadJobs = datalink; 
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);

        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["product"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  _loadPurchaseQuantity() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_purchasequantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        print("Now: Purchase is EMPTY");
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  SizedBox buildOutlineButton({IconData icon, Function press}) {
    return SizedBox(
      width: 40,
      height: 32,
      child: OutlineButton(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        onPressed: press,
        child: Icon(icon),
      ),
    );
  }

  void _addToPurchase(int index) {
  
    try {
      int cquantity =
          int.parse(productdata[index]["quantity"]); //current available qty
      print(cquantity);
      print(productdata[index]["id"]);
      print(widget.user.email);
      // print(productdata[index]["price"]);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Purchasing...");
        pr.show();
        String urlLoadJobs = insertlink;
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": productdata[index]['id'],
          "quantity": numOfItem.toString(), //qtty you chose
        }).then((res) {
          print(res.body);
          if (res.body.contains("failed")) {
            Toast.show("Fail. Not added to Purchase", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          } else {
            List respond = res.body.split(",");
            setState(() {
              numOfItem = respond[1];
              widget.user.quantity = numOfItem.toString();
            });
            Toast.show("Success. Added to Purchase", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

            _loadPurchaseQuantity();
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
  }
}

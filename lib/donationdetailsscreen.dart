import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:shimmer/shimmer.dart';

import 'donate.dart';
import 'donationscreen.dart';
import 'user.dart';
import 'purchasescreen.dart';

class DonationDetailScreen extends StatefulWidget {
  final Donate donate;
  final User user;

  const DonationDetailScreen({Key key, this.donate, this.user}) : super(key: key);

  @override
  _DonationDetailScreenState createState() => _DonationDetailScreenState();
}

class _DonationDetailScreenState extends State<DonationDetailScreen> {
  List donatedetails;
  String titlecenter = "Loading donate details...";
  double screenHeight, screenWidth;
  String amountRM;
  String donateAmount = "0";
  final amountFormKey = GlobalKey<FormState>();

  TextEditingController donationController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();

  void initState() {
    super.initState();
    _loadDonateDetails();
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
        title: Text('Donate Details',
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
            SizedBox(height: 15.0),
            donatedetails == null
                ? Flexible(
                    child: Container(
                        child: Center(
                    child: Shimmer.fromColors(
                        baseColor: Colors.black,
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
                        itemCount: donatedetails == null ? 0 : donatedetails.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: screenHeight / 2.6,  //height between card
                            width: screenWidth / 2.5,
                            child: Column(
                              children: <Widget>[
                                Card(
                                    elevation: 10,
                                    margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Container(
                                                  height: screenWidth / 4.3,
                                                  width: screenWidth / 4.5,
                                                  child: ClipRect(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.scaleDown,
                                                    imageUrl:
                                                        "http://yitengsze.com/a_gifhope/charityimages/${donatedetails[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ))),
                                              SizedBox(height: 10),
                                              Text(donatedetails[index]['genre'],
                                                  style: TextStyle(
                                                      fontSize: 17.0)),
                                            ],
                                          ),
                                          Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 1, 10, 1),
                                              child: SizedBox(
                                                  width: 3,
                                                  child: Container(
                                                    height: screenWidth /
                                                        2.3, //charity card's height
                                                    color: Colors.grey,
                                                  ))),
                                          Container(
                                              width: screenWidth / 1.5,
                                              child: Row(
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          donatedetails[index]['name'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17.0),
                                                          maxLines: 3,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Text(
                                                            "RM " +  donatedetails[index]['total'],
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17.0,
                                                                color:
                                                                    Colors.red),
                                                            maxLines: 3,
                                                          ),
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  "Email: " +
                                                                      donatedetails[index] ['email'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0)),
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
                                                                  'Donate again',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                  )),
                                                              color: Colors.yellow[300],
                                                              textColor: Colors.black,
                                                              elevation: 10,
                                                              onPressed: () => {
                                                                donateAgain(index)
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
                                                              color: Colors.yellow[300],
                                                              textColor: Colors.black,
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
                                        ]))),
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

  _loadDonateDetails() async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_donationHistory.php"; 

    await http.post(urlLoadJobs, body: {
      "donateid": widget.donate.donateid,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        setState(() {
          donatedetails = null;
          titlecenter = "No Donate Record";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          donatedetails = extractdata["donate"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> donateAgain(int index) async {

    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new RichText(
                text: TextSpan(
                  text: "Donate to ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan( text: donatedetails[index]['name'], 
                              style: TextStyle( 
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                ))]
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Insert donation amount: ",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),

                  //Row insert amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Form(
                          key: amountFormKey,
                          child: TextFormField(
                              controller: donationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'RM',
                                  icon: Icon(Icons.attach_money)),
                              validator: amountValidate,
                              onSaved: (String rm) {
                                amountRM = rm;
                              }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    child: Text("Yes",
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                    onPressed: () {
                      if (amountFormKey.currentState.validate()) {
                        amountController.text = donationController.text;
                        addToPurchaseAgain(index);
                        Navigator.of(context).pop(false);
                      }
                    }),
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

  String amountValidate(String amount) {
    print(amount);
    if (amount.isEmpty) {
      return 'Amount is required';
    }

    if (amount == '0') {
      return 'Please enter amount more than 0';
    }

    return null;
  }

  addToPurchaseAgain(int index) {
    String qtyDonate = "1";
    String amountRM = amountController.text;
    final amountFK = amountFormKey.currentState;
    try {
      var id = donatedetails[index]["id"];
      print(id);
      print(widget.user.email);

      if (amountFK.validate()) {
        amountFK.save();

        // ProgressDialog pr = new ProgressDialog(context,
        //     type: ProgressDialogType.Normal, isDismissible: false);
        // pr.style(message: "Add to Donation...");
        // pr.show();

        String urlLoadJobs =
            "https://yitengsze.com/a_gifhope/php/insert_donation.php";

        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "eventid": donatedetails[index]['id'],
          "amount": amountRM.toString(),
          "qtydonate": qtyDonate,
          "donor": widget.user.name,
          "contact": widget.user.phone,
        }).then((res) {

          print(res.body);
          if (res.body.contains("failed")) {
            Toast.show("Donation Failed", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }

          else {
            List respond = res.body.split(",");
            setState(() {
              qtyDonate = respond[2];
            });
            Toast.show("Donation Success", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DonationScreen(
                          user: widget.user,
                         // charity: donatedetails[index]['id'],
                        )));
            //pr.hide();
          }
        }).catchError((err) {
          print(err);
          // pr.hide();
        });
        // pr.hide();
      }
  }

  catch (e) {
      Toast.show("Donate Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PurchaseScreen(
                  user: widget.user,
                  id: donatedetails[index]['id'],
                )));
}}
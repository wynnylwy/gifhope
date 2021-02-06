import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gifhope/admincharity.dart';
import 'package:gifhope/adminproduct.dart';
import 'package:gifhope/bookdetailscreen.dart';

import 'package:gifhope/mainscreen.dart';
import 'package:gifhope/profilescreen.dart';
import 'package:gifhope/purchasescreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:gifhope/user.dart';

import 'donationscreen.dart';
import 'loginscreen.dart';

class CharityScreen extends StatefulWidget {
  final User user;
  CharityScreen({Key key, this.user}) : super(key: key);

  @override
  _CharityScreenState createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List charitydata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String donatequantity = "0";
   String numOfItem = "0";
  int quantity = 1;

  bool _isAdmin = false;
  String amount;
  String titlecenter = "Charity data is not found";

  TextEditingController searchController = new TextEditingController();
  TextEditingController donationController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();

  final amountFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadCharityData();
    _loadDonationQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();

    if (widget.user.email == "charityadmin@gifhope.com") {
      _isAdmin = true;
    }
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
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
            title: Text('Charity List',
                style: TextStyle(
                    fontFamily: 'Sofia',
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.black)),
            actions: <Widget>[
              IconButton(
                  icon: _visible
                      ? new Icon(Icons.expand_more)
                      : new Icon(Icons.expand_less),
                  onPressed: () {
                    setState(() {
                      if (_visible) {
                        _visible = false;
                      } else {
                        _visible = true;
                      }
                    });
                  }),
            ],
          ),
          body: RefreshIndicator(
              key: refreshKey,
              color: Colors.red,
              onRefresh: () async {
                await refreshList();
              },
              child: Container(
                color: Colors.red[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                      visible: _visible,
                      child: Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("Recent"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.update,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Recent",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("COVID-19"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.coronavirus,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "COVID-19",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () =>
                                          _sortItem("Food Security"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.food_bank,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Food Security",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("Children"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.child_care,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Children",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("Education"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            Icons.school,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Education",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("Animals"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.dog,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Animals",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                      onPressed: () => _sortItem("Disaster"),
                                      color: Colors.yellow[400],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.emoticonCryOutline,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Disaster",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: _visible,
                      child: Card(
                        elevation: 5,
                        child: Container(
                          height: screenHeight / 12,
                          margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                  height: 30,
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    autofocus: false,
                                    controller: searchController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.search),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: MaterialButton(
                                  color: Colors.yellow[400],
                                  onPressed: () =>
                                      {_sortItembyName(searchController.text)},
                                  elevation: 5,
                                  child: Text(
                                    "Search ",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      curtype,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
//grid
                    charitydata == null
                        ? Flexible(
                            child: Container(
                                color: Colors.red[100],
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
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 0.9,
                              children:
                                  List.generate(charitydata.length, (index) {
                                return Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            height: screenWidth / 2.5,
                                            width: screenWidth / 2.5,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl:
                                                    "http://yitengsze.com/a_gifhope/charityimages/${charitydata[index]['id']}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            charitydata[index]['name'],
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "-----------------------------",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.tag),
                                              Text(
                                                " Genre: ",
                                              ),
                                              Text(
                                                charitydata[index]['genre'],
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.volunteer_activism,
                                                  color: Colors.black),
                                              Text(" Target: RM "),
                                              Text(
                                                charitydata[index]['target'],
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          MaterialButton(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minWidth: 120,
                                              height: 40,
                                              child: Text('View Details'),
                                              color: Colors.yellow[400],
                                              textColor: Colors.black,
                                              onPressed: () {
                                                _viewDetails(index);
                                              }),
                                        ],
                                      ),
                                    ));
                              }),
                            ),
                          ),
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.red[700],
              onPressed: () async {
                if (widget.user.email.contains("unregistered")) {
                  Toast.show("Please register first", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else if (widget.user.email
                    .contains("charityadmin@gifhope.com")) {
                  Toast.show("Admin Mode", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else if (widget.user.donation == '0') {
                  Toast.show("Donation Empty", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DonationScreen(
                                user: widget.user,
                              )));
                }
                _loadCharityData(); //refresh data
                _loadCharityDonateAmount();
              },
              icon: Icon(Icons.volunteer_activism),
              label: Text(widget.user.donation,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ));
  }

  void _loadCharityData() async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_charity.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);
        donatequantity = "0";
        titlecenter = "No charity found";
        setState(() {
          charitydata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          charitydata = extractdata["charity"];
          donatequantity = widget.user.donation;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadDonationQuantity() async {
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_donationQuantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      if (res.body.contains("nodata")) {
        print("Now: Donation is EMPTY");
      } else {
        widget.user.donation = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadCharityData();
    return null;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Exit App',
              style: TextStyle(color: Colors.black),
            ),
            content: new Text(
              'Do you want to exit this App?',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: Text(
                  "Exit",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name,
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            accountEmail: Text(widget.user.email,
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
            otherAccountsPictures: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Text(widget.user.credit,
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
              ),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0, color: Colors.white),
              ),
              backgroundImage: NetworkImage(
                  "http://yitengsze.com/a_gifhope/profileimages/${widget.user.email}.jpg"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ProfileScreen(user: widget.user)))
            },
          ),

          ListTile(
              title: Text("My Profile",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProfileScreen(user: widget.user)),
                    )
                  }),

          ListTile(
              title: Text("My Purchase",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BookingScreen(user: widget.user)),
                    )
                  }),

          ListTile(
              title: Text("Purchase History",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BookDetailScreen(user: widget.user)),
                    )
                  }),

          ListTile(
              title: Text("Go To Donation List",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    //goToPaymentHistory(),
                  }),

          ListTile(
              title: Text("Back to Product List",
                  style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MainScreen(user: widget.user)),
                    )
                  }),

          ListTile(
              title: Text("Log Out", style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    _logout(),
                  }),

          //Admin Menu
          Visibility(
            visible: _isAdmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 3,
                  color: Colors.black,
                ),
                Center(
                  child: Text("Seller Menu",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                ListTile(
                  title: Text("Manage Product Info",
                      style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AdminProduct(user: widget.user)))
                  },
                ),
                // ListTile(
                //   title: Text("Sales History", style: TextStyle(fontSize: 16)),
                //   trailing: Icon(Icons.arrow_forward),
                //   // onTap: () => {
                //   //   Navigator.pop(context),
                //   //   Navigator.push(
                //   //       context,
                //   //       MaterialPageRoute(
                //   //           builder: (BuildContext context) =>
                //   //               AdminProduct(user: widget.user))

                //   //               )
                //   // },
                // ),
                ListTile(
                  title:
                      Text("View Sales Report", style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward),
                  // onTap: () => {
                  //   Navigator.pop(context),
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               AdminProduct(user: widget.user))

                  //               )
                  // },
                ),
                ListTile(
                  title: Text("View Donation Report",
                      style: TextStyle(fontSize: 16)),
                  trailing: Icon(Icons.arrow_forward),
                  // onTap: () => {
                  //   Navigator.pop(context),
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               AdminProduct(user: widget.user))

                  //               )
                  // },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sortItem(String genre) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_charity.php";
      http.post(urlLoadJobs, body: {
        "genre": genre,
      }).then((res) {
        print(res.body);
        if (res.body.contains("nodata")) {
          setState(() {
            charitydata = null;
            curtype = genre;
          });
        } else {
          setState(() {
            curtype = genre;
            var extractdata = json.decode(res.body);
            charitydata = extractdata["charity"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.hide();
          });
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String eventname) {
    try {
      print(eventname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_charity.php";
      http
          .post(urlLoadJobs, body: {
            "name": eventname.toString(),
          })
          .timeout(const Duration(seconds: 3))
          .then((res) {
            print(res.body);
            if (res.body.contains("nodata")) {
              Toast.show("Event not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No event found";
                curtype = "Search for" + "'" + eventname + "'";
                eventname = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                charitydata = extractdata["charity"];
                FocusScope.of(context).requestFocus(new FocusNode());
                pr.hide();
              });
            }
          })
          .catchError((err) {
            pr.hide();
          });

      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _viewDetails(int index) {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    screenWidth = MediaQuery.of(context).textScaleFactor;

    try {
      print(charitydata[index]["id"]);
      print(widget.user.email);

      showModalBottomSheet(
          backgroundColor: Colors.red[100],
          context: context,
          isScrollControlled: true,
          builder: (BuildContext builder) {
            return Container(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 15, 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: IconButton(
                                icon: Icon(Icons.close),
                                iconSize: 18.0,
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.fromLTRB(3, 20, 5, 5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: screenHeight / 4,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              3, 10, 5, 5),
                                          child: Text(
                                            charitydata[index]['name'],
                                            maxLines: 5,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ])),
                          ]),
                    ),
                    ClipRect(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl:
                            "http://yitengsze.com/a_gifhope/charityimages/${charitydata[index]['id']}.jpg",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.tag,
                                color: Colors.blue[500],
                              ),
                              Text(
                                charitydata[index]['genre'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                          child: Icon(
                            Icons.save_alt,
                            color: Colors.blue[500],
                          ),
                        ),
                        Text(
                          "Received: RM ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          charitydata[index]['received'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Icon(
                          Icons.volunteer_activism,
                          color: Colors.blue[500],
                        ),
                        Text(
                          " Target: RM ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          charitydata[index]['target'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: Colors.blue[500],
                              ),
                              Text("Start Date: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                charitydata[index]['start_datetime'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.date_range,
                                color: Colors.blue[500],
                              ),
                              Text("End Date: ",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                charitydata[index]['end_datetime'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 50),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text("DESCRIPTION",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(38, 5, 38, 5),
                      child: Text(charitydata[index]['description'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    MaterialButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minWidth: 150,
                      height: 40,
                      child: Text(
                        "Donate It".toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      color: Colors.yellow[400],
                      textColor: Colors.black,
                      onPressed: () {
                        _addToDonateDialog(index);

                      },
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),
                  ],
                ),
              ),
            );
          });
    } catch (e) {
      print(e);
      Toast.show("Show details Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //donate dialog
  _addToDonateDialog(int index) {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (widget.user.email.contains("seller@gifhope.com")) {
      Toast.show("Seller Mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: new Text("Donate to " + charitydata[index]['name'],
                  style: TextStyle(
                      // fontFamily: 'Bellota',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
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
                                amount = rm;
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
                        _addToDonation(index);
                        Navigator.of(context).pop(false);
                      }
                    }),
                MaterialButton(
                    child: Text("Cancel",
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ],
            );
          });
        }); //Builder + Dialog
  }

  void _logout() {
    print(widget.user.name);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text("Log Out",
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              content: new Text("Are you sure?",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  )),
              actions: <Widget>[
                new FlatButton(
                    child: new Text("Yes",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    }),
                new FlatButton(
                    child: new Text("No",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    onPressed: () => {Navigator.of(context).pop()})
              ]);
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

  _addToDonation(int index) {
    String qtyDonate = "1";
    String amount = amountController.text;
    final amountFK = amountFormKey.currentState;

    try {
      print(amount);
      print(amountFK);

      if (amountFK.validate()) {
        amountFK.save();

        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: false);
        pr.style(message: "Add to Donation...");
        pr.show();

        String urlLoadJobs =
            "https://yitengsze.com/a_gifhope/php/insert_donation.php";

        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "eventid": charitydata[index]['id'],
          "amount": amount.toString(),
          "qtydonate": qtyDonate,
          "donor": widget.user.name,
          "contact": widget.user.phone,
        }).then((res) {
          print(res.body);

          if (res.body.contains("success")) {
            Navigator.of(context).pop();
            Toast.show("Added to Donation", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            return;
          }
        }).catchError((err) {
          print(err);
        });
      } else {
        Toast.show("Not added to Donation", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    } catch (e) {
      Toast.show("Donation Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadCharityDonateAmount() async {
    String loadLink = "https://yitengsze.com/a_gifhope/php/load_donationQuantity.php";
    await http.post(loadLink, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);

      if (res.body.contains("nodata")) {
        print("Now: Donation is EMPTY");
      } else {
        widget.user.donation = res.body;  //did not receive data 
      }
    }).catchError((err) {
      print(err);
    });
  }
}
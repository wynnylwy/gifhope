import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifhope/cadminMainScreen.dart';
import 'package:gifhope/profilescreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:gifhope/user.dart';

import 'charity.dart';
import 'collectdonationtile.dart';
import 'loginscreen.dart';
import 'newcharity.dart';
import 'report_donate.dart';
import 'report_sales.dart';
import 'updatecharity.dart';

class CharityAdminManageScreen extends StatefulWidget {
  final User user;
  CharityAdminManageScreen({Key key, this.user}) : super(key: key);

  @override
  _CharityAdminManageScreenState createState() =>
      _CharityAdminManageScreenState();
}

class _CharityAdminManageScreenState extends State<CharityAdminManageScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List charitydata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String donatequantity = "0";
  int quantity = 1;
  String titlecenter = "Charity data is not found";
  var _tapPosition;

  @override
  void initState() {
    super.initState();
    _loadCharityData();
    _loadDonationQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _charityController = new TextEditingController();

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFFFF7043),
                      const Color(0xFFFF8A65),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            title: Text('Manage Charity Info',
                style: TextStyle(
                    fontFamily: 'Sofia',
                    fontWeight: FontWeight.bold,
                    fontSize: 26.0,
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
                            child: genreDropDownList(),
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
                                    controller: _charityController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.search),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: MaterialButton(
                                  color: Colors.red[100],
                                  onPressed: () => {
                                    _sortItembyName(_charityController.text)
                                  },
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
                                  (screenWidth / screenHeight) / 1.0,
                              children:
                                  List.generate(charitydata.length, (index) {
                                return Container(
                                  child: InkWell(
                                    onTap: () => _showPopUpMenu(index),
                                    onTapDown: _storePosition,
                                    child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 5),
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
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "-----------------------------",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  Icon(
                                                      Icons.volunteer_activism),
                                                  Text(
                                                    " Target: RM  ",
                                                  ),
                                                  Text(
                                                    charitydata[index]
                                                        ['target'],
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height:8),
                                              MaterialButton(
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  minWidth: 120,
                                                  height: 40,
                                                  child: Text('View Details'),
                                                  color: Colors.red[400],
                                                  textColor: Colors.white,
                                                  onPressed: () {
                                                    _viewDetails(index);
                                                  }),
                                            ],
                                          ),
                                        )),
                                  ),
                                );
                              }),
                            ),
                          ),
                  ],
                ),
              )),
          floatingActionButton: SpeedDial(
            backgroundColor: Colors.red[500],
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                backgroundColor: Colors.red[300],
                child: Icon(Icons.add_to_drive),
                label: "Create New Charity Info",
                labelBackgroundColor: Colors.red[300],
                onTap: _createNewCharity,
              ),
              SpeedDialChild(
                child: Icon(Icons.request_page),
                backgroundColor: Colors.red[300],
                label: "View Sales Report",
                labelBackgroundColor: Colors.red[300],
                onTap: _viewSalesReport,
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.scriptText),
                backgroundColor: Colors.red[300],
                label: "View Donation Report",
                labelBackgroundColor: Colors.red[300],
                onTap: _viewDonateReport,
              ),
              SpeedDialChild(
                child: Icon(Icons.volunteer_activism),
                backgroundColor: Colors.red[300],
                label: "Collect Donation",
                labelBackgroundColor: Colors.red[300],
                onTap: _collectDonation,
              ),
            ],
          ),
        ));
  }

  void _loadCharityData() async {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_charity.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);
        // donatequantity = "0";
        titlecenter = "No charity found";
        setState(() {
          charitydata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          charitydata = extractdata["charity"];
          // donatequantity = widget.user.quantity;
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
        widget.user.quantity = res.body;
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
      child: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                const Color(0xFFFF8A65),
                const Color(0xFFFF7043),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: new LinearGradient(
                      colors: [
                        const Color(0xFFFF8A65),
                        const Color(0xFFFF7043),
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              accountName: Text(widget.user.name,
                  style: TextStyle(fontSize: 18.0, color: Colors.black)),
              accountEmail: Text(widget.user.email,
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
              otherAccountsPictures: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Text(widget.user.credit,
                      style: TextStyle(fontSize: 12.0, color: Colors.black)),
                ),
              ],
              currentAccountPicture: CircleAvatar(
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
                  title: Text("Charity List",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(Icons.list, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CharityAdminMainScreen(user: widget.user)))
                      }),
              ListTile(
                  title: Text("Manage Charity Info",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(MdiIcons.databaseEdit, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CharityAdminManageScreen(user: widget.user)))
                      }),
              ListTile(
                  title: Text("Collect Donation",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(Icons.attach_money, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CollectDonationTileScreen()))
                      }),
              ListTile(
                  title: Text("View Sales Report",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(Icons.request_page, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SalesReportScreen()))
                      }),
              ListTile(
                  title: Text("View Donation Report",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(MdiIcons.scriptText, color: Colors.black),
                  onTap: () => {
                        Navigator.pop(context),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    DonateReportScreen()))
                      }),
              ListTile(
                  title: Text("Log Out",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  leading: Icon(Icons.logout, color: Colors.black),
                  onTap: () => {
                        _logout(),
                      }),
          ],
        ),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: Icon(
                            Icons.save_alt,
                            color: Colors.blue[500],
                          ),
                        ),
                        Text(
                          "Received: RM ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          charitydata[index]['received'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.5,
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
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          charitydata[index]['target'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.5,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
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
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
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

  Future<void> _createNewCharity() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewCharity()));
    _loadCharityData();
  }

  Future<void> _collectDonation() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => CollectDonationTileScreen()));
  }

  Future<void> _viewSalesReport() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => SalesReportScreen()));
  }

  Future<void> _viewDonateReport() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => DonateReportScreen()));
  }

  void _storePosition(TapDownDetails details) {
     _tapPosition = details.globalPosition;
  }

  _showPopUpMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, pop up after touch on touch's area
          Offset.zero & overlay.size), // Bigger rect, the entire screen
      items: [
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Update Event Info"),
          onTap: () => {Navigator.of(context).pop(), _onEventDetail(index)},
        )),
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Delete Event Info"),
          onTap: () => {Navigator.of(context).pop(), _deleteEventDialog(index)},
        )),
      ],
      elevation: 8.0,
    );
  }

  Widget genreDropDownList()
  {
    return Row(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                child: TextButton(
                  onPressed: () => _sortItem("Recent"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Icon(
                        MdiIcons.update,
                        size: 55.0,
                        color: Colors.black,
                      ),
                      new Text(
                        "Recent",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("COVID-19"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/covid19.png',
                        height: 60,
                        width: 50,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "COVID-19",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Food Security"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/food.png',
                        height: 60,
                        width: 75,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Food Security",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(
          width: 3,
        ),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Children"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/refugee.png',
                        height: 65,
                        width: 70,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Children",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(
          width: 3,
        ),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Education"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/education.png',
                        height: 65,
                        width: 75,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Education",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(
          width: 3,
        ),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Animals"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/animals.png',
                        height: 70,
                        width: 75,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Animals",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
        Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () => _sortItem("Disaster"),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Image.asset(
                        'assets/images/disaster.png',
                        height: 75,
                        width: 70,
                        fit: BoxFit.fitWidth,
                      ),
                      new Text(
                        "Disaster",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15.0),
                      )
                    ],
                  ),
                ))
          ],
        ),
        SizedBox(width: 3),
      ],
    );
  }

  Future<void> _onEventDetail(int index) async {
    print(charitydata[index]['id']);
    print(charitydata[index]['name']);
     

    Charity charityInfo = new Charity(
        eid: charitydata[index]['id'],
        name: charitydata[index]['name'],
        startDateTime: charitydata[index]['start_datetime'],
        endDateTime: charitydata[index]['end_datetime'],
        genre: charitydata[index]['genre'],
        received: charitydata[index]['received'],
        target: charitydata[index]['target'],
        description: charitydata[index]['description'],
        contact: charitydata[index]['contact']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateCharity(
                  user: widget.user,
                  charity: charityInfo,
                )));
    _loadCharityData();
  }

  void _deleteEventDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text("Delete Event ID: " + charitydata[index]['id']),
            content: new Text(
              "Are you sure? ",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteEvent(index);
                  },
                  child: new Text(
                    "Yes",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  )),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: new Text(
                  "No",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _deleteEvent(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting event...");
    pr.show();
    http.post("https://yitengsze.com/a_gifhope/php/delete_charity.php", body: { 
      "eid": charitydata[index]['id'],
    }).then((res) {
      print(res.body);
      pr.hide();

      if (res.body.contains("success")) {
        Toast.show("Delete successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCharityData(); //refresh data
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    _loadCharityData();
  }
}

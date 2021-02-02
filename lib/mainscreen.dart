import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gifhope/paymenthistoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:gifhope/user.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'detailsScreen.dart';
import 'loginscreen.dart';
import 'product.dart';
import 'bookingscreen.dart';
import 'profilescreen.dart';
import 'adminproduct.dart';

class MainScreen extends StatefulWidget {
  final User user;
  final Product product;

  const MainScreen({Key key, this.user, this.product}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartNum = "0";
  int quantity = 1;
  bool _isSeller = false;
  String titlecenter = "Product data is not found";
  String datalink = "https://yitengsze.com/a_gifhope/php/load_product.php";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadPurchaseQuantity();

    refreshKey = GlobalKey<RefreshIndicatorState>();

    if (widget.user.email == "seller@gifhope.com") {
      _isSeller = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _productController = new TextEditingController();

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
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
            title: Text('Product List',
                style: TextStyle(
                    fontFamily: 'Sofia',
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.white)),
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
                color: Colors.blue[800],
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
                                      color: Colors.yellow[200],
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
                                      onPressed: () =>
                                          _sortItem("Women Clothing"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Icon(
                                              MdiIcons.genderFemale,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                            Icon(
                                              MdiIcons.hanger,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                          ]),
                                          Text(
                                            "Women Clothing",
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
                                          _sortItem("Men Clothing"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Icon(
                                              MdiIcons.genderMale,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                            Icon(
                                              MdiIcons.hanger,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                          ]),
                                          Text(
                                            "Men Clothing",
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
                                      onPressed: () => _sortItem("Women Shoes"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Icon(
                                              MdiIcons.genderFemale,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                            Icon(
                                              MdiIcons.walk,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                          ]),
                                          Text(
                                            "Women Shoes",
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
                                      onPressed: () => _sortItem("Men Shoes"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Row(children: <Widget>[
                                            Icon(
                                              MdiIcons.genderMale,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                            Icon(
                                              MdiIcons.walk,
                                              size: 35.0,
                                              color: Colors.black,
                                            ),
                                          ]),
                                          Text(
                                            "Men Shoes",
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
                                      onPressed: () =>
                                          _sortItem("Bag & Wallet"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.shopping,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Bag & Wallet",
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
                                          _sortItem("Book & Stationery"),
                                      color: Colors.yellow[200],
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Icon(
                                            MdiIcons.bookOpen,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Book & Stationery",
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
                                    controller: _productController,
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.search),
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: MaterialButton(
                                  color: Colors.yellow[200],
                                  onPressed: () => {
                                    _sortItembyName(_productController.text)
                                  },
                                  elevation: 5,
                                  child: Text(
                                    "Search ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
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
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
//grid
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
                            child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio:
                                  (screenWidth / screenHeight) / 0.9,
                              children:
                                  List.generate(productdata.length, (index) {
                                return Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 10),
                                      child: GestureDetector(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              height: screenWidth / 2.5,
                                              width: screenWidth / 2.5,
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl:
                                                      "http://yitengsze.com/a_gifhope/productimages/${productdata[index]['id']}.jpg",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              productdata[index]['name'],
                                              maxLines: 3,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
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
                                                  maxLines: 3,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.tag),
                                                Text(
                                                  " " +
                                                      productdata[index]
                                                          ['genre'],
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(MdiIcons.checkDecagram,
                                                    color: Colors.blue),
                                                Text(" Qty available: " +
                                                    productdata[index]
                                                        ['quantity']),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.attach_money,
                                                  color: Colors.black,
                                                ),
                                                Text(" Price: RM " +
                                                    productdata[index]['price'])
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailsScreen(
                                                product: productdata[index],
                                                user: widget.user,
                                              ),
                                            )),
                                      ),
                                    ));
                              }),
                            ),
                          ),
                  ],
                ),
              )),
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                if (widget.user.email.contains("unregistered")) {
                  Toast.show("Please register first", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else if (widget.user.email.contains("seller@gifhope.com")) {
                  Toast.show("Seller Mode", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else if (widget.user.quantity == "0") {
                  Toast.show("Purchase Empty", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  return;
                } else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => BookingScreen(
                                user: widget.user,
                              )));
                }

                _loadData(); //refresh data
                _loadPurchaseQuantity();
              },
              icon: Icon(Icons.add_shopping_cart),
              label:
                  Text(cartNum, style: TextStyle(fontWeight: FontWeight.bold))),
        ));
  }

  void _loadData() async {
    String urlLoadJobs = datalink;
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body.contains("nodata")) {
        print(res.body);
        cartNum = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          productdata = extractdata["product"];
          cartNum = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
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
                    goToBookings(),
                  }),

          ListTile(
              title: Text("Purchase History",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    goToPaymentHistory(),
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
                    _loadData(),
                  }),

          ListTile(
              title: Text("Log Out", style: TextStyle(color: Colors.black)),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    _logout(),
                  }),

          //Admin Menu
          Visibility(
            visible: _isSeller,
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

  void choiceAction(String choice) {
    print("Type");
  }

  void _viewDetails(int index) {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email.contains("admin@gifhope.com")) {
      Toast.show("Admin mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      print(productdata[index]["id"]);
      print(widget.user.email);

      // BookingScreen(user: widget.user)

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => DetailsScreen(
      //               product: widget.product,
      //               index: index,
      //             ))); //DONE!!

    } catch (e) {
      Toast.show("Show details Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //booking dialog
  _addToBookingsDialog(int index) {
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
              title: new Text("Purchase for " + productdata[index]['name'],
                  style: TextStyle(
                      fontFamily: 'Bellota',
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select purchase quantity: ",
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
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
                                (int.parse(productdata[index]['quantity']) -
                                    2)) {
                              quantity++;
                            } else {
                              Toast.show(
                                  "Product quantity is not available", context,
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
                          fontSize: 15.0,
                        )),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      //_addToPurchase(index);
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

  goToBookings() async {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email.contains("seller@gifhope.com")) {
      Toast.show("Seller mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity.contains("0")) {
      Toast.show("Purchase Empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookingScreen(user: widget.user)));
      _loadData();
      _loadPurchaseQuantity();
    }
  }

  goToPaymentHistory() async {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email.contains("seller@gifhope.com")) {
      Toast.show("Seller mode", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  PaymentHistoryScreen(user: widget.user)));
    }
  }

  void _sortItem(String genre) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_product.php";
      http.post(urlLoadJobs, body: {
        "genre": genre,
      }).then((res) {
        print(res.body);
        if (res.body.contains("nodata")) {
          setState(() {
            productdata = null;
            curtype = genre;
          });
        } else {
          setState(() {
            curtype = genre;
            var extractdata = json.decode(res.body);
            productdata = extractdata["product"];
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

  void _sortItembyName(String productname) {
    try {
      print(productname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://yitengsze.com/a_gifhope/php/load_product.php";
      http
          .post(urlLoadJobs, body: {
            "name": productname.toString(),
          })
          .timeout(const Duration(seconds: 3))
          .then((res) {
            print(res.body);
            if (res.body.contains("nodata")) {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.hide();
              setState(() {
                titlecenter = "No product found";
                curtype = "Search for" + "'" + productname + "'";
                productname = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["product"];
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

  void _loadPurchaseQuantity() async {
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
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gifhope/detailsScreen.dart';
import 'package:gifhope/sellerDetailsScreen.dart';
import 'package:gifhope/user.dart';
import 'package:gifhope/editproduct.dart';
import 'package:gifhope/newproduct.dart';
import 'package:gifhope/product.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shimmer/shimmer.dart';

import 'bookingscreen.dart';
import 'reportlist.dart';

class AdminProduct extends StatefulWidget {
  final User user;

  const AdminProduct({Key key, this.user}) : super(key: key);

  @override
  _AdminProductState createState() => _AdminProductState();
}

class _AdminProductState extends State<AdminProduct> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String cartquantity = "0";
  int quantity = 1;
  var _tapPosition;
  String titlecenter = "Product data is not found";
  

  @override
  void initState() {
    super.initState();
    _loadData();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _productController = new TextEditingController();

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
        title: Text('Manage Product Info',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
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
                                          Icon(
                                            MdiIcons.car,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
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
                                          Icon(
                                            MdiIcons.carHatchback,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
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
                                          Icon(
                                            MdiIcons.caravan,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
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
                                          Icon(
                                            MdiIcons.carSports,
                                            size: 35.0,
                                            color: Colors.black,
                                          ),
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
                                            MdiIcons.carConvertible,
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
                                            MdiIcons.carConvertible,
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
                                    style: TextStyle(color: Colors.black),
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
                                    "Product data not found",
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
                          childAspectRatio: (screenWidth / screenHeight) / 0.9,
                          children: List.generate(productdata.length, (index) {
                            return Container(
                              child: InkWell(
                                onTap: () => _showPopUpMenu(index),
                                onTapDown: _storePosition, //menu position
                                child: Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: EdgeInsets.all(5),
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
                                                    SellerDetailsScreen(
                                                  product: productdata[index],
                                                  user: widget.user,
                                                ),
                                              )),
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
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            child: Icon(Icons.add_to_drive),
            label: "New Product Info",
            labelBackgroundColor: Colors.blue[200],
            onTap: createNewProduct,
          ),
          SpeedDialChild(
            child: Icon(Icons.request_page),
            label: "View Sales Report",
            labelBackgroundColor: Colors.blue[200],
            onTap: createNewProduct,
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.scriptText),
            label: "View Donation Report",
            labelBackgroundColor: Colors.blue[200],
            onTap: report,
          ),
        ],
      ),
    );
  }

  void _loadData() {
    String urlLoadJobs = "https://yitengsze.com/a_gifhope/php/load_product.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        productdata = extractdata["product"];
        cartquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  goToBookings() {
    if (widget.user.email.contains("unregistered")) {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookingScreen(user: widget.user)));
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
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

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
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

    } catch (e) {
      Toast.show("Show details Failed", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _showPopUpMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition &
              Size(40, 40), // smaller rect, pop up after touch on touch's area
          Offset.zero & overlay.size), // Bigger rect, the entire screen
      items: [
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Update Product Info"),
          onTap: () => {Navigator.of(context).pop(), _onCarDetail(index)},
        )),
        PopupMenuItem(
            child: GestureDetector(
          child: Text("Delete Product Info"),
          onTap: () => {Navigator.of(context).pop(), _deleteCarDialog(index)},
        )),
      ],
      elevation: 8.0,
    );
  }

  Future<void> _onCarDetail(int index) async {
    print(productdata[index]['name']);
    Product cars = new Product(
        pid: productdata[index]['id'],
        name: productdata[index]['name'],
        price: productdata[index]['price'],
        genre: productdata[index]['genre'],
        description: productdata[index]['description'],
        date: productdata[index]['date']);

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditProduct(
                  user: widget.user,
                  product: cars,
                )));
    _loadData();
  }

  void _deleteCarDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text("Delete Product ID: " + productdata[index]['id']),
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
                    _deleteCar(index);
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

  void _deleteCar(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting car...");
    pr.show();
    http.post("https://yitengsze.com/carVroom/php/delete_cars.php", body: {  //chg!
      "proid": productdata[index]['id'],
    }).then((res) {
      print(res.body);
      pr.hide();

      if (res.body.contains("success")) {
        Toast.show("Delete successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData(); //refresh data
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    _loadData();
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct()));
    _loadData();
  }

  Future<void> report() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => ReportList()));
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gifhope/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'order.dart';
import 'product.dart';
import 'payment.dart';
import 'mainscreen.dart';

class BookingScreen extends StatefulWidget {
  final User user;
  
  final String id;
  final Product product;

  const BookingScreen({Key key, this.user, this.id, this.product})
      : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List purchaseData;
  double screenHeight, screenWidth;
  bool _selfPickup = true;
  bool _locationDelivery = false;
  double _rentalFees = 0.0, _discountFees = 0.0, _totalPayment = 0.0;
  double discount;
  double amountpayable;
  Position _currentPosition;
  String curaddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;

  @override
  void initState() {
    super.initState();
    _getLocation(); //get current location
    _loadBookings();
  }

  @override
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
          title: Text('Purchase',
              style: TextStyle(
                  fontFamily: 'Sofia',
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.white)),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MainScreen(
                              user: widget.user,
                            )));
              }),
          actions: <Widget>[
            IconButton(
                icon: Icon(MdiIcons.deleteEmpty),
                onPressed: () {
                  deleleAll();
                }),
          ],
        ),
        body: Container(
            color: Colors.blue[800],
            child: Center(
              child: Column(
                children: <Widget>[
                  Text("Here's Your Purchase",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      )),
                  purchaseData == null
                      ? Flexible(
                          child: Container(
                              color: Colors.blue[800],
                              child: Center(
                                child: Shimmer.fromColors(
                                    baseColor: Colors.yellow[500],
                                    highlightColor: Colors.white,
                                    child: Text(
                                      "Loading Your Purchase...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Mogra',
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )),
                              )))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: purchaseData == null
                                  ? 1
                                  : purchaseData.length + 2,
                              itemBuilder: (context, index) {
                                if (index == purchaseData.length) {
                                  return Container(
                                      height: screenHeight / 3.0,
                                      width: screenWidth / 2.5,
                                      child: InkWell(
                                        onLongPress: () => {print("Delete")},
                                        child: Card(
                                          color: Colors.yellow[200],
                                          elevation: 5,
                                          margin: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          
                                          child: Column(
                                            children: <Widget>[
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Delivery Option",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Expanded(
                                                  child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: screenWidth / 2.2,
                                                    height: screenHeight / 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              value:
                                                                  _selfPickup,
                                                              onChanged:
                                                                  (bool value) {
                                                                _onSelfPickup(
                                                                    value);
                                                              },
                                                            ),
                                                            Text(
                                                                "Self-PickUp "),
                                                          ],
                                                        ),
                                                        Text(
                                                          "(30 % Discount)",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB( 2, 1, 2, 1),
                                                      child: SizedBox(
                                                          width: 3,
                                                          child: Container(
                                                            height:screenWidth / 2,
                                                            color: Colors.grey,
                                                          ))),
                                                  Expanded(
                                                      child: Container(
                                                    width: screenWidth / 2,
                                                    height: screenHeight / 3,
                                                    child: Column(
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            Checkbox(
                                                              value:
                                                                  _locationDelivery,
                                                              onChanged:
                                                                  (bool value) {
                                                                _onLocationDelivery(
                                                                    value);
                                                              },
                                                            ),
                                                            Text(
                                                                "Home Delivery "),
                                                          ],
                                                        ),
                                                        FlatButton(
                                                          color: Colors.blue,
                                                          onPressed: () => {
                                                            _loadMapDialog()
                                                          },
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Text("Current Address:",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Row(
                                                          children: <Widget>[
                                                            Text("  "),
                                                            Flexible(
                                                              child: Text(
                                                                curaddress ??
                                                                    "Address not set",
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                                ],
                                              ))
                                            ],
                                          ),
                                        ),
                                      ));
                                }

                                if (index == purchaseData.length + 1) {
                                  return Container(
                                    height: screenHeight / 3.2,
                                    child: Card(
                                      elevation: 5,
                                      margin:
                                          EdgeInsets.fromLTRB(10, 10, 10, 8),
                                      
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Summary of Payment",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          Text(
                                              "Purchase Fees: RM " +
                                                      _rentalFees
                                                          .toStringAsFixed(2) ??
                                                  "0.0",
                                              style: TextStyle(
                                                fontSize: 16.0,
                                              )),
                                          SizedBox(height: 10),
                                          Text(
                                              "Discount Fees: RM " +
                                                      _discountFees
                                                          .toStringAsFixed(2) ??
                                                  "0.0",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 16.0,
                                              )),
                                          SizedBox(height: 20),
                                          Text(
                                              "TOTAL AMOUNT RM: " +
                                                      _totalPayment
                                                          .toStringAsFixed(2) ??
                                                  "0.0",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          SizedBox(
                                            height: 18,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 100,
                                                height: 50,
                                                child: Text('Make Payment',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    )),
                                                color: Colors.blue[500],
                                                textColor: Colors.white,
                                                elevation: 10,
                                                onPressed: makePayment,
                                              ),
                                              MaterialButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                minWidth: 140,
                                                height: 50,
                                                child: Text('Cancel',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    )),
                                                color: Colors.blue[500],
                                                textColor: Colors.white,
                                                elevation: 10,
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                index -= 0;

                                return Card(
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
                                                  height: screenWidth / 4.8,
                                                  width: screenWidth / 4.5,
                                                  child: ClipOval(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.scaleDown,
                                                    imageUrl:
                                                        "http://yitengsze.com/a_gifhope/productimages/${purchaseData[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ))),
                                              Text(
                                                  "RM " +
                                                      purchaseData[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      fontSize: 17.0)),
                                              Text("/ item ",
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
                                                    height: screenWidth / 1.8,
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
                                                          purchaseData[index]
                                                              ['name'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16.0),
                                                          maxLines: 3,
                                                        ),
                                                        Row(
                                                             mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  "Genre: " +
                                                                      purchaseData[
                                                                              index]
                                                                          [
                                                                          'genre'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0)),
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                  "Available: " +
                                                                      purchaseData[
                                                                              index]
                                                                          [
                                                                          'quantity'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0)),
                                                            ]),
                                                        SizedBox(height: 15),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text(
                                                                "Selected quantity: " +
                                                                    purchaseData[
                                                                            index]
                                                                        [
                                                                        'cquantity'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                )),
                                                            Spacer(flex: 2),
                                                            Text(
                                                                "RM " +
                                                                    purchaseData[
                                                                            index]
                                                                        [
                                                                        'yourprice'],
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17.0)),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Text("Add more: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0)),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            FlatButton(
                                                              onPressed: () => {
                                                                _updateBookings(
                                                                    index,
                                                                    "add")
                                                              },
                                                              child: Icon(
                                                                MdiIcons.plus,
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                            ),
                                                            Text(
                                                                purchaseData[
                                                                        index][
                                                                    'cquantity'],
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.0,
                                                                )),
                                                            FlatButton(
                                                              onPressed: () => {
                                                                _updateBookings(
                                                                    index,
                                                                    "remove")
                                                              },
                                                              child: Icon(
                                                                MdiIcons.minus,
                                                                color: Colors
                                                                    .blue[600],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: <Widget>[
                                                              FlatButton(
                                                                onPressed: () =>
                                                                    {
                                                                  _deleteBookings(
                                                                      index)
                                                                },
                                                                child: Icon(
                                                                  MdiIcons
                                                                      .delete,
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                ),
                                                              ),
                                                            ]),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ])));
                              }),
                        ),
                ],
              ),
            )));
  }

  void _loadBookings() {
    _totalPayment = 0.0;
    _rentalFees = 0.0;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Purchase Updating...");
    pr.show();
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/load_purchase.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.hide();
      if (res.body.contains("Purchase Empty")) {
        widget.user.quantity = "0"; //let the purchase num =0
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        purchaseData = extractdata["purchase"];
        for (int i = 0; i < purchaseData.length; i++) {
          _rentalFees =
              double.parse(purchaseData[i]['yourprice']) + _rentalFees;
        }

        _totalPayment = _rentalFees;

        print(_rentalFees);
      });
    }).catchError((err) {
      print(err);
      pr.hide();
    });
    pr.hide();
  }

  //Button + / -
  _updateBookings(int index, String op) {
    int curquantity = int.parse(purchaseData[index]['quantity']);
    int quantity = int.parse(purchaseData[index]['cquantity']);
    if (op.contains("add")) {
      quantity++;
      if (quantity > (curquantity + 1)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }

    if (op.contains("remove")) {
      quantity--;
      if (quantity == 0) {
        _deleteBookings(index);
        return;
      }
    }
    String urlLoadJobs =
        "https://yitengsze.com/a_gifhope/php/update_purchase.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": purchaseData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body.contains("success")) {
        Toast.show("Purchase updating...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadBookings();
      } else {
        Toast.show("Purchase failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteBookings(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Delete product?',
            style: TextStyle(
              fontFamily: 'Bellota',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        actions: <Widget>[
          MaterialButton(
              child: Text("Yes",
                  style: TextStyle(
                    fontSize: 15.0,
                  )),
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(
                    "https://yitengsze.com/a_gifhope/php/delete_purchase.php",
                    body: {
                      "email": widget.user.email,
                      "prodid": purchaseData[index]['id'],
                    }).then((res) {
                  print(res.body);
                  if (res.body.contains("success")) {
                    _loadBookings();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
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
      ),
    );
  }

  void _onSelfPickup(bool newValue) => setState(() {
        _selfPickup = newValue;
        if (_selfPickup) {
          _locationDelivery = false;
          _updatePayment();
        } else {
          _locationDelivery = true;
          _updatePayment();
        }
      });

  void _onLocationDelivery(bool newValue) {
    _getLocation();
    setState(() {
      _locationDelivery = newValue;

      if (_locationDelivery) {
        _updatePayment();
        _selfPickup = false;
      } else {
        _updatePayment();
      }
    });
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }

      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text("Select New Delivery Location"),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  Text(curaddress,
                      style: TextStyle(
                        fontSize: 15.0,
                      )),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Done'),
                    color: Colors.blue[500],
                    textColor: Colors.white,
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)},
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  void _updatePayment() {
    _totalPayment = 0.0;
    _discountFees = 0.0;
    _rentalFees = 0.0;

    setState(() {
      for (int i = 0; i < purchaseData.length; i++) {
        _rentalFees = double.parse(purchaseData[i]['yourprice']) + _rentalFees;
      }

      //print(_selfPickup);

      if (_selfPickup) {
        discount = 0.3;
        _discountFees = _rentalFees * discount;
        _totalPayment = _rentalFees - _discountFees;
        print("Discount (selfPickup): RM " + _discountFees.toString());
      }

      if (_locationDelivery) {
        discount = 0.00;
        _discountFees = _rentalFees * discount;
        _totalPayment = _rentalFees - _discountFees;
        print("Discount (locationDelivery): RM " + _discountFees.toString());
      }

      print("Purchase Fees: RM " + _rentalFees.toString());
      print("Discount Fees: RM " + _discountFees.toString());
      print("Total Payment: RM " + _totalPayment.toString());
    });
  }

  Future<void> makePayment() async {
    if (_selfPickup) {
      print("SELF PICK-UP");
      Toast.show("Chosen: SELF PICK-UP", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_locationDelivery) {
      print("HOME DELIVERY");
      Toast.show("Chosen: HOME DELIVERY", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please select payment option !!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Make Payment? ',
          style: TextStyle(
            fontFamily: 'Bellota',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text("Yes",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                )),
            onPressed: () {
              var now = new DateTime.now(); //current time
              var dateFormat = new DateFormat('dd-MM-yyyy hh:mm a');
              String orderid = widget.user.email.substring(0, 5) +
                  "-" +
                  dateFormat.format(now) +
                  randomAlphaNumeric(6);

              print(orderid);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => PaymentScreen(
                            user: widget.user,
                            val: _totalPayment.toStringAsFixed(2),
                            orderid: orderid,
                          ))).then((result) {
                Navigator.of(context).pop();
              });
            },
          ),
          MaterialButton(
            child: Text("Cancel",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                )),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );

    _loadBookings();
  }

  void deleleAll() {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: new Text('Delete all products?',
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontWeight: FontWeight.bold,
                  )),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      http.post(
                          "https://yitengsze.com/a_gifhope/php/delete_purchase.php",
                          body: {
                            "email": widget.user.email,
                          }).then((res) {
                        print(res.body);

                        if (res.body.contains("success")) {
                          _loadBookings();
                        } else {
                          Toast.show("Failed", context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                        }
                      }).catchError((err) {
                        print(err);
                      });
                    }),
                MaterialButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
              ],
            ));
  }
}

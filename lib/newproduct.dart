import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

class NewProduct extends StatefulWidget {
  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/camera.jpg";
  String _scanBarCode = "Click here to scan";
  var _tapPosition;
   TextEditingController idEditingController = new TextEditingController();
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController specEditingController = new TextEditingController();
  TextEditingController seatsEditingController = new TextEditingController();
  TextEditingController doorsEditingController = new TextEditingController();
  TextEditingController brandEditingController = new TextEditingController();
  TextEditingController aircondEditingController = new TextEditingController();
  TextEditingController airbagEditingController = new TextEditingController();
  TextEditingController luggageEditingController = new TextEditingController();
  TextEditingController descriptionEditingController = new TextEditingController();

  FocusNode _idFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _genreFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
 
  String selectedGenre;

  static const rowSpacer=TableRow(
                  children: [
                      SizedBox(
                      height: 8,
                      ),
                      SizedBox(
                      height: 8,
                      )
                ]);

  List<String> listGenre = [
    "Women Clothing",
    "Men Clothing",
    "Women Shoe",
    "Men Shoe",
    "Bag & Wallet",
    "Book & Stationery"
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        title: Text('New Product',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
      ),
      body: Center(
        child: Container(  //pic container
          
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () => {_choose()}, //open camera
                  child: Container(
                    height: screenHeight / 3,
                    width: screenWidth / 1.8,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: _image == null
                            ? AssetImage(pathAsset)
                            : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        width: 4,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text("Click the camera to take product picture",
                    style: TextStyle(
                      fontSize: 14.0, 
                      color: Colors.black)),

                Container(   //table container
                  width: screenWidth / 1.1,
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Table(
                            defaultColumnWidth: FlexColumnWidth(5.0),
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text("Product ID:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),

                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: TextFormField(
                                        focusNode: _idFocusNode, //current focus
                                        autofocus: true,
                                        controller: idEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(context, _idFocusNode, _nameFocusNode);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          fillColor: Colors.blue[400],
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),


                                  //* Scan barcocde, QR code, add ID manually
                                  // TableCell(
                                  //   child: Container(
                                  //     alignment: Alignment.centerLeft,
                                  //     height: 30,
                                  //     child: GestureDetector(   //textform field + chg focus node!
                                  //       onTap: _showPopUpMenu,
                                  //       onTapDown: _storePosition,
                                  //       child: Text(_scanBarCode),
                                  //     ),
                                  //   ),
                                  // ),
                                  
                                ],
                                
                              ),

                              rowSpacer, 

                                
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text("Product Name:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: TextFormField(
                                        focusNode: _nameFocusNode, //current focus
                                        autofocus: true,
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(context, _nameFocusNode, _priceFocusNode);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          fillColor: Colors.blue[400],
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              rowSpacer, 
                              rowSpacer, 

                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Price (RM):",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: TextFormField(
                                        focusNode: _priceFocusNode, //current focus
                                        autofocus: true,
                                        controller: priceEditingController,
                                        keyboardType: TextInputType.text,                                        
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                         fieldFocusChange(context, _priceFocusNode, _genreFocusNode);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          fillColor: Colors.blue[400],
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              rowSpacer, 

                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      child: Text("Genre:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 50,
                                      child: DropdownButton(
                                        hint: Text('Genre'),
                                        items: listGenre.map((selectedGenre) {
                                          return DropdownMenuItem(
                                              child: new Text(selectedGenre),
                                              value: selectedGenre);
                                        }).toList(),
                                        value: selectedGenre,
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedGenre = newValue;
                                            print(selectedGenre);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                             TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Quantity:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),

                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: TextFormField(
                                        focusNode: _quantityFocusNode, //current focus
                                        autofocus: true,
                                        controller: qtyEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(context, _quantityFocusNode, _descriptionFocusNode);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          fillColor: Colors.blue[400],
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 80,
                                      child: Text("Description:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 120,
                                      child: TextFormField(
                                        focusNode: _descriptionFocusNode,
                                        autofocus: true,
                                        controller: descriptionEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (v) {
                                          fieldFocusChange(context, _descriptionFocusNode, _descriptionFocusNode);
                                        },
                                        decoration: new InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(6),
                                          fillColor: Colors.blue[400],
                                          border: new OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(6),
                                            borderSide: new BorderSide(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                            ],
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minWidth: screenWidth / 3.0,
                                height: 40,
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                color: Colors.yellow[200],
                                textColor: Colors.black,
                                elevation: 10,
                                onPressed: _addNewCarDialog,
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                minWidth: screenWidth / 3.0,
                                height: 40,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                color: Colors.yellow[200],
                                textColor: Colors.black,
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _choose() async //set image frame is 800:800
  {
    _image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path, //choose taken pic's path
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
              ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue[600],
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  _showPopUpMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
            child: GestureDetector(
                child: Text("Scan Barcode"),
                onTap: () => {
                      Navigator.of(context).pop,
                      onGetID(),
                    })),
        PopupMenuItem(
            child: GestureDetector(
                child: Text("Scan QR Code"),
                onTap: () => {
                      Navigator.of(context).pop,
                      scanQR(),
                    })),
        PopupMenuItem(
            child: GestureDetector(
                child: Text("Add ID Manually"),
                onTap: () => {
                      Navigator.of(context).pop,
                      manualID(),
                    }))
      ],
      elevation: 8,
    );
  }

  void onGetID() {
    scanBarcodeNormal();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeRes;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      barcodeRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeRes);
    } on PlatformException {
      barcodeRes = "Failed to get platform version";
    }

    if (!mounted) return;
    setState(() {
      if (barcodeRes == "-1") {
        _scanBarCode = "Click here to scan";
      } else {
        _scanBarCode = barcodeRes;
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeRes;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      barcodeRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeRes);
    } on PlatformException {
      barcodeRes = "Failed to get platform version";
    }

    if (!mounted) return;
    setState(() {
      _scanBarCode = barcodeRes;
    });
  }

  manualID() {
    TextEditingController carIDManual = new TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Enter new Car ID "),
            content: new Container(
              margin: EdgeInsets.fromLTRB(6, 2, 6, 2),
              height: 30,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                controller: carIDManual,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0),
                    borderSide: new BorderSide(),
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes",
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    if (carIDManual.text.length > 2) {
                      _scanBarCode = carIDManual.text;
                    } else {}
                  });
                },
              ),
              new FlatButton(
                child: new Text("No",
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _addNewCarDialog() {
    if (_scanBarCode.contains("Click here to scan")) {
      Toast.show("Please scan car ID", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (_image == null) {
      Toast.show("Please take product picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (idEditingController.text.length < 3) {
      Toast.show("Please enter product ID", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (nameEditingController.text.length < 3) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
   

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Add new product? " ,
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
          content: new Text("Name: " + nameEditingController.text, 
                        style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                addNewCar();
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  addNewCar() {
    double price = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Adding new product...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post("https://yitengsze.com/a_gifhope/php/insert_product.php", body: {
        "pid": idEditingController.text,
        "name": nameEditingController.text,
        "price": price.toStringAsFixed(2),
        "genre": selectedGenre,
        "quantity": qtyEditingController.text,
        "description": descriptionEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Added success, please check through screen/ search bar.",
              context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Added failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } else {
      http.post("https://yitengsze.com/a_gifhope/php/insert_product.php", body: {
        "pid": idEditingController.text,
        "name": nameEditingController.text,
        "price": price.toStringAsFixed(2),
        "genre": selectedGenre,
        "quantity": qtyEditingController.text,
        "description": descriptionEditingController.text,
      }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Update success. Please check through screen/ search bar.",
              context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
  }

  void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

}

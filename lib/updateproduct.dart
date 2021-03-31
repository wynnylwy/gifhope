import 'dart:convert';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'product.dart';
import 'user.dart';

class UpdateProduct extends StatefulWidget {
  final User user;
  final Product product;

  const UpdateProduct({Key key, this.user, this.product}) : super(key: key);
  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
 
 double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/camera.jpg";

  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController descriptionEditingController = new TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _priceFocusNode = FocusNode();
  FocusNode _genreFocusNode = FocusNode();
  FocusNode _quantityFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
 
  bool _takePicture = true;
  bool _takePictureLocal = false;
  String selectedGenre;

  static const rowSpacer = TableRow(children: [
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
    "Women Shoes",
    "Men Shoes",
    "Bag & Wallet",
    "Book & Stationery"
  ];

  

  @override
  void initState() {
    super.initState();
    print("Edit Product");
    nameEditingController.text = widget.product.name; //assign current value in d/b into textfield
    priceEditingController.text = widget.product.price;
    qtyEditingController.text = widget.product.quantity;
    descriptionEditingController.text = widget.product.description;
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Colors.deepOrange[200],
                  Colors.red[100],
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('Update Product',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: Container(
        //pic container
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takePicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              "http://yitengsze.com/a_gifhope/productimages/${widget.product.pid}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _takePictureLocal,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop),
                            image: _image == null
                                ? AssetImage('assets/images/camera.jpg')
                                : FileImage(_image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Container(
                  //table container
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
                                      child: Text(widget.product.pid),
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
                                        focusNode:
                                            _nameFocusNode, //current focus
                                        autofocus: true,
                                        controller: nameEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(context,
                                              _nameFocusNode, _priceFocusNode);
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
                                        focusNode:
                                            _priceFocusNode, //current focus
                                        autofocus: true,
                                        controller: priceEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(context,
                                              _priceFocusNode, _genreFocusNode);
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
                                        hint: Text(widget.product.genre),
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
                                        focusNode:
                                            _quantityFocusNode, //current focus
                                        autofocus: true,
                                        controller: qtyEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(
                                              context,
                                              _quantityFocusNode,
                                              _descriptionFocusNode);
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
                                        controller:
                                            descriptionEditingController,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (v) {
                                          fieldFocusChange(
                                              context,
                                              _descriptionFocusNode,
                                              _descriptionFocusNode);
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
                                  'Update',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                color: Colors.yellow[300],
                                textColor: Colors.black,
                                elevation: 10,
                                onPressed: updateProductDialog,
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
                                color: Colors.yellow[300],
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
    );
  }

  updateProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Update Product ID: " + widget.product.pid,
                  style: TextStyle(
                    // fontFamily: 'Bellota',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                updateProduct();
              },
            ),
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateProduct()async{
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
    
    if (descriptionEditingController.text.length < 1) {
      Toast.show("Please enter description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    double price = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating product...");
    pr.show();

    String base64Image;

    if (_image != null)  {
      
      base64Image = base64Encode(_image.readAsBytesSync());

      http.post("https://yitengsze.com/a_gifhope/php/update_product.php", body: {
        
        "pid": widget.product.pid,
        "name": nameEditingController.text,
        "price": price.toStringAsFixed(2),
        "quantity": qtyEditingController.text,
        "genre": selectedGenre,
        "description": descriptionEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.hide();

        
        if (res.body.contains("success")) {
          Toast.show("Update success, please check through screen/ search bar.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } 
        
        else {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });

      await DefaultCacheManager().removeFile('http://yitengsze.com/a_gifhope/productimages/${widget.product.pid}.jpg');
    } 
    
    else {
      http.post("https://yitengsze.com/a_gifhope/php/update_product.php", body: {
        "pid": widget.product.pid,
        "name": nameEditingController.text,
        "price": price.toStringAsFixed(2),
        "quantity": qtyEditingController.text,
        "genre": selectedGenre,
        "description": descriptionEditingController.text,
      }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) 
        {
          Toast.show("Update success, please check through screen/ search bar.", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } 
        
        else 
        {
          Toast.show("Update failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
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
          toolbarColor: Colors.red[100],
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));

    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _takePicture = false; 
        _takePictureLocal = true;
      });
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

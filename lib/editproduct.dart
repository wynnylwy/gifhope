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

class EditProduct extends StatefulWidget {
  final User user;
  final Product product;

  const EditProduct({Key key, this.user, this.product}) : super(key: key);
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController carnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  //TextEditingController soldEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController specEditingController = new TextEditingController();
  TextEditingController seatsEditingController = new TextEditingController();
  TextEditingController doorsEditingController = new TextEditingController();
  TextEditingController brandEditingController = new TextEditingController();
  TextEditingController aircondEditingController = new TextEditingController();
  TextEditingController airbagEditingController = new TextEditingController();
  TextEditingController luggageEditingController = new TextEditingController();
  TextEditingController descriptionEditingController = new TextEditingController();

  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();
  final focus8 = FocusNode();
  File _image;
  bool _takePicture = true;
  bool _takePictureLocal = false;
  String selectedType;
  String selectedSpecification;
  String selectedAircond;
  String selectedBrand;

  List<String> listType = [
    "Sedan",
    "Hatchback",
    "MPV",
    "SUV",
    "Convertible",
  ];

  List<String> listSpec = [
    "Manual",
    "Automatic",
  ];

  List<String> listAircond = [
    "Yes",
    "No",
  ];

  List<String> listBrand = [
    "Honda",
    "Perodua",
    "Toyota",
    "Mazda",
    "Proton",
    "Mercedes-Benz",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    print("Edit Product");
    carnameEditingController.text = widget.product.name; //assign current value in d/b into textfield
    priceEditingController.text = widget.product.price;
    typeEditingController.text = widget.product.genre;
    descriptionEditingController.text = widget.product.description;
  }

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
        title: Text('Update Product Info',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white)),
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
                              "http://yitengsze.com/carVroom/carsimages/${widget.product.pid}.jpg",
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
                width: screenWidth / 1.2,
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Table(
                          defaultColumnWidth: FlexColumnWidth(1.0),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("Car ID:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(" " + widget.product.pid),
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
                                    child: Text("Car Name:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: carnameEditingController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus0);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Price (RM):",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: priceEditingController,
                                      keyboardType: TextInputType.text,
                                      focusNode: focus0, //past focus
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context).requestFocus(
                                            focus1); //current focus 1
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Quantity:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: qtyEditingController,
                                      keyboardType: TextInputType.number,
                                      focusNode: focus1,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus2);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Type:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: DropdownButton(
                                      hint: Text('Type'),
                                      items: listType.map((selectedType) {
                                        return DropdownMenuItem(
                                            child: new Text(selectedType),
                                            value: selectedType);
                                      }).toList(),
                                      value: selectedType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedType = newValue;
                                          print(selectedType);
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
                                    child: Text("Specification:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: DropdownButton(
                                      hint: Text('Specification'),
                                      items:
                                          listSpec.map((selectedSpecification) {
                                        return DropdownMenuItem(
                                            child:
                                                new Text(selectedSpecification),
                                            value: selectedSpecification);
                                      }).toList(),
                                      value: selectedSpecification,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedSpecification = newValue;
                                          print(selectedSpecification);
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
                                    child: Text("Seats:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: seatsEditingController,
                                      keyboardType: TextInputType.number,
                                      focusNode: focus2, //past focus
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus3);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Doors:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: doorsEditingController,
                                      keyboardType: TextInputType.number,
                                      focusNode: focus3, //past focus
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus4);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Air-cond:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: DropdownButton(
                                      hint: Text('Air-cond'),
                                      items: listAircond.map((selectedAircond) {
                                        return DropdownMenuItem(
                                            child: new Text(selectedAircond),
                                            value: selectedAircond);
                                      }).toList(),
                                      value: selectedAircond,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedAircond = newValue;
                                          print(selectedAircond);
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
                                    child: Text("Air-bag:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: airbagEditingController,
                                      keyboardType: TextInputType.number,
                                      focusNode: focus4, //past focus
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus5);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Luggage:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: TextFormField(
                                      controller: luggageEditingController,
                                      keyboardType: TextInputType.number,
                                      focusNode: focus5, //past focus
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus6);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 120,
                                    child: TextFormField(
                                      controller: descriptionEditingController,
                                      keyboardType: TextInputType.text,
                                      focusNode: focus6,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus7);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(6),
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
                                    height: 30,
                                    child: Text("Brand:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ),
                                TableCell(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: DropdownButton(
                                      hint: Text('Brand'),
                                      items: listBrand.map((selectedBrand) {
                                        return DropdownMenuItem(
                                            child: new Text(selectedBrand),
                                            value: selectedBrand);
                                      }).toList(),
                                      value: selectedBrand,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedBrand = newValue;
                                          print(selectedBrand);
                                        });
                                      },
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
                                style: TextStyle(fontSize: 18.0),
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
                                style: TextStyle(fontSize: 18.0),
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
          title: Text("Update Car ID " + widget.product.pid,
                  style: TextStyle(
                    fontFamily: 'Bellota',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
          content: new Text("Are you sure?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                    fontSize: 17,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                updateCar();
              },
            ),
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
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

  void updateCar()async{
    if (carnameEditingController.text.length < 3) {
      Toast.show("Please enter car name", context,
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
    if (seatsEditingController.text.length < 1) {
      Toast.show("Please enter seats", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (doorsEditingController.text.length < 1) {
      Toast.show("Please enter doors", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (airbagEditingController.text.length < 1) {
      Toast.show("Please enter air-bag", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (luggageEditingController.text.length < 1) {
      Toast.show("Please enter luggage", context,
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
    pr.style(message: "Updating car...");
    pr.show();

    String base64Image;

    if (_image != null)  {
      
      base64Image = base64Encode(_image.readAsBytesSync());

      http.post("https://yitengsze.com/carVroom/php/update_cars.php", body: {
        
        "carid": widget.product.pid,
        "carname": carnameEditingController.text,
        "price": price.toStringAsFixed(2),
        "quantity": qtyEditingController.text,
        "type": selectedType,
        "specification": selectedSpecification,
        "seats": seatsEditingController.text,
        "doors": doorsEditingController.text,
        "aircond": selectedAircond,
        "airbag": airbagEditingController.text,
        "luggage": luggageEditingController.text,
        "description": descriptionEditingController.text,
        "brand": selectedBrand,
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

      await DefaultCacheManager().removeFile('http://yitengsze.com/carVroom/carsimages/${widget.product.pid}.jpg');
    } 
    
    else {
      http.post("https://yitengsze.com/carVroom/php/update_cars.php", body: {
        "carid": widget.product.pid,
        "carname": carnameEditingController.text,
        "price": price.toStringAsFixed(2),
        "quantity": qtyEditingController.text,
        "type": selectedType,
        "specification": selectedSpecification,
        "seats": seatsEditingController.text,
        "doors": doorsEditingController.text,
        "aircond": selectedAircond,
        "airbag": airbagEditingController.text,
        "luggage": luggageEditingController.text,
        "description": descriptionEditingController.text,
        "brand": selectedBrand,
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
          toolbarColor: Colors.blue[600],
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
}

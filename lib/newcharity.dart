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
import 'package:intl/intl.dart';

class NewCharity extends StatefulWidget {
  @override
  _NewCharityState createState() => _NewCharityState();
}

class _NewCharityState extends State<NewCharity> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/camera.jpg";
  // String _scanBarCode = "Click here to scan";
  // var _tapPosition;

  String startDate = "D:M:Y";
  String endDate = "D:M:Y";
  String startTime = "h:m:s";
  String endTime = "h:m:s";
  String combinedStart, combinedEnd;
  DateTime chosenStartDate = DateTime.now();
  DateTime chosenEndDate = DateTime.now();
  DateTime chosenStartTime = DateTime.now();
  DateTime chosenEndTime = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-dd-MM'); 
  final DateFormat timeFormat = DateFormat('HH:mm:ss'); 

  TextEditingController idEditingController = new TextEditingController();
  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController receivedEditingController = new TextEditingController();
  TextEditingController targetEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController descriptionEditingController = new TextEditingController();
  TextEditingController contactEditingController = new TextEditingController();

  FocusNode _idFocusNode = FocusNode();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _receivedFocusNode = FocusNode();
  FocusNode _targetFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _contactFocusNode = FocusNode();

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
    "COVID-19",
    "Food Security",
    "Children",
    "Education",
    "Animals",
    "Disaster"
  ];

  @override
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
                  const Color(0xFFFDD835),
                  const Color(0xFFFBC02D),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: Text('New Charity',
            style: TextStyle(
                fontFamily: 'Sofia',
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.black)),
      ),
      body: Center(
        child: Container(
          //pic container

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
                Text("Click the camera to take event picture",
                    style: TextStyle(fontSize: 14.0, color: Colors.black)),
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
                                      child: Text("Event ID:",
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
                                          fieldFocusChange(context,
                                              _idFocusNode, _nameFocusNode);
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
                                      child: Text("Event Name:",
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
                                          fieldFocusChange(
                                              context,
                                              _nameFocusNode,
                                              _receivedFocusNode);
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
                                      child: Text("Date & Time:",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 90,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Start Date",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    height: 1.8,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                "End Date",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    height: 1.8,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 70,
                                                height: 45,
                                                child: RaisedButton(
                                                  color: Colors.amber[100],
                                                  child: Text(
                                                    startDate,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  onPressed: () async {
                                                    final selectedStartDate =await _selectDate(context);

                                                    if (selectedStartDate ==null) return;
                                                    print(selectedStartDate);

                                                    setState(() {
                                                      chosenStartDate =
                                                          DateTime(
                                                        selectedStartDate.day,
                                                        selectedStartDate.month,
                                                        selectedStartDate.year,
                                                      );

                                                      startDate = dateFormat.format(selectedStartDate);
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                width: 70,
                                                height: 45,
                                                child: RaisedButton(
                                                  color: Colors.amber[100],
                                                  child: Text(
                                                    endDate,
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  onPressed: () async {
                                                    final selectedEndDate =
                                                        await _selectDate(
                                                            context);

                                                    if (selectedEndDate == null)
                                                      return;
                                                    print(selectedEndDate);

                                                    setState(() {
                                                      chosenEndDate =
                                                          DateTime(
                                                        selectedEndDate.day,
                                                        selectedEndDate.month,
                                                        selectedEndDate.year,
                                                      );

                                                      endDate =
                                                          dateFormat.format(
                                                              selectedEndDate);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                                      height: 50,
                                      child: Text("",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          )),
                                    ),
                                  ),
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Start Time",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(width: 20),
                                              Text(
                                                "End Time",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 70,
                                                height: 45,
                                                child: RaisedButton(
                                                  color: Colors.amber[100],
                                                  child: Text(
                                                    startTime, //startTime
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  onPressed: () async {
                                                    final selectedStartTime = await _selectTime(context);

                                                    if (selectedStartTime == null) return;
                                                    print(selectedStartTime);

                                                    setState(() {
                                                      chosenStartTime =DateTime(
                                                        selectedStartTime.hour,
                                                        selectedStartTime.minute,
                                                      );

                                                      startTime = formatStartTimeOfDay(selectedStartTime);
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                width: 70,
                                                height: 45,
                                                child: RaisedButton(
                                                  color: Colors.amber[100],
                                                  child: Text(
                                                    endTime,
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  onPressed: () async {
                                                    final selectedEndTime = await _selectTime(context);

                                                    if (selectedEndTime == null)
                                                      return;
                                                    print(selectedEndTime);

                                                    setState(() {
                                                      chosenEndTime =DateTime(
                                                        selectedEndTime.hour,
                                                        selectedEndTime.minute,
                                                      );

                                                      endTime = formatStartTimeOfDay(selectedEndTime);
                                                    
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                              rowSpacer,
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Received : (RM)",
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
                                            _receivedFocusNode, //current focus
                                        autofocus: true,
                                        controller: receivedEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(
                                              context,
                                              _receivedFocusNode,
                                              _targetFocusNode);
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
                                      height: 30,
                                      child: Text("Target : (RM)",
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
                                            _targetFocusNode, //current focus
                                        autofocus: true,
                                        controller: targetEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(
                                              context,
                                              _targetFocusNode,
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
                              rowSpacer,
                              TableRow(
                                children: [
                                  TableCell(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 60,
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
                                      height: 60,
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
                                              _contactFocusNode);
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
                                      height: 30,
                                      child: Text("Contact No.:",
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
                                            _contactFocusNode, //current focus
                                        autofocus: true,
                                        controller: contactEditingController,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onFieldSubmitted: (_) {
                                          fieldFocusChange(
                                              context,
                                              _contactFocusNode,
                                              _contactFocusNode);
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
                          SizedBox(height: 18),
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
                                color: Colors.amber[100],
                                textColor: Colors.black,
                                elevation: 10,
                                onPressed: _addNewEventDialog,
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
                                color: Colors.amber[100],
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

  // void _storePosition(TapDownDetails details) {
  //   _tapPosition = details.globalPosition;
  // }

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
          toolbarColor: Colors.amber[300],
          toolbarWidgetColor: Colors.black,
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

  // _showPopUpMenu() async {
  //   final RenderBox overlay = Overlay.of(context).context.findRenderObject();

  //   await showMenu(
  //     context: context,
  //     position: RelativeRect.fromRect(
  //         _tapPosition & Size(40, 40), Offset.zero & overlay.size),
  //     items: [
  //       PopupMenuItem(
  //           child: GestureDetector(
  //               child: Text("Scan Barcode"),
  //               onTap: () => {
  //                     Navigator.of(context).pop,
  //                     onGetID(),
  //                   })),
  //       PopupMenuItem(
  //           child: GestureDetector(
  //               child: Text("Scan QR Code"),
  //               onTap: () => {
  //                     Navigator.of(context).pop,
  //                     scanQR(),
  //                   })),
  //       PopupMenuItem(
  //           child: GestureDetector(
  //               child: Text("Add ID Manually"),
  //               onTap: () => {
  //                     Navigator.of(context).pop,
  //                     manualID(),
  //                   }))
  //     ],
  //     elevation: 8,
  //   );
  // }

  // void onGetID() {
  //   scanBarcodeNormal();
  // }

  // Future<void> scanBarcodeNormal() async {
  //   String barcodeRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.

  //   try {
  //     barcodeRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.BARCODE);
  //     print(barcodeRes);
  //   } on PlatformException {
  //     barcodeRes = "Failed to get platform version";
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     if (barcodeRes == "-1") {
  //       _scanBarCode = "Click here to scan";
  //     } else {
  //       _scanBarCode = barcodeRes;
  //     }
  //   });
  // }

  // Future<void> scanQR() async {
  //   String barcodeRes;
  //   // Platform messages may fail, so we use a try/catch PlatformException.

  //   try {
  //     barcodeRes = await FlutterBarcodeScanner.scanBarcode(
  //         "#ff6666", "Cancel", true, ScanMode.BARCODE);
  //     print(barcodeRes);
  //   } on PlatformException {
  //     barcodeRes = "Failed to get platform version";
  //   }

  //   if (!mounted) return;
  //   setState(() {
  //     _scanBarCode = barcodeRes;
  //   });
  // }

  // manualID() {
  //   TextEditingController carIDManual = new TextEditingController();
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(20.0))),
  //           title: new Text("Enter new Car ID "),
  //           content: new Container(
  //             margin: EdgeInsets.fromLTRB(6, 2, 6, 2),
  //             height: 30,
  //             child: TextFormField(
  //               style: TextStyle(color: Colors.black),
  //               controller: carIDManual,
  //               keyboardType: TextInputType.number,
  //               textInputAction: TextInputAction.next,
  //               decoration: new InputDecoration(
  //                 fillColor: Colors.white,
  //                 border: new OutlineInputBorder(
  //                   borderRadius: new BorderRadius.circular(5.0),
  //                   borderSide: new BorderSide(),
  //                 ),
  //               ),
  //             ),
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text("Yes",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 setState(() {
  //                   if (carIDManual.text.length > 2) {
  //                     _scanBarCode = carIDManual.text;
  //                   } else {}
  //                 });
  //               },
  //             ),
  //             new FlatButton(
  //               child: new Text("No",
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                   )),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }

  void _addNewEventDialog() {
    // if (_scanBarCode.contains("Click here to scan")) {
    //   Toast.show("Please scan car ID", context,
    //       duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //   return;
    // }
    if (_image == null) {
      Toast.show("Please take event picture", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (idEditingController.text.length < 3) {
      Toast.show("Please enter event ID", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (nameEditingController.text.length < 3) {
      Toast.show("Please enter event name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (receivedEditingController.text.length < 1) {
      Toast.show("Please enter received amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (targetEditingController.text.length < 1) {
      Toast.show("Please enter target amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (contactEditingController.text.length < 1) {
      Toast.show("Please enter contact no.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Add new event? ",
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
                addNewEvent();
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

  addNewEvent() {
    double received = double.parse(receivedEditingController.text);
    double target = double.parse(targetEditingController.text);
    String startDatetime = startDate + ' ' + startTime;
    String endDatetime = endDate + ' ' + endTime;

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Adding new event ...");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post("https://yitengsze.com/a_gifhope/php/insert_charity.php",
          body: {
            "eid": idEditingController.text,
            "name": nameEditingController.text,
            "start_datetime": startDatetime,
            "end_datetime": endDatetime,
            "genre": selectedGenre,
            "received": received.toStringAsFixed(2),
            "target": target.toStringAsFixed(2),
            "description": descriptionEditingController.text,
            "contact": contactEditingController.text,
            "encoded_string": base64Image,
          }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Added SUCCESS, please check through screen/ search bar.",
              context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Added FAILED", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    } else {
      http.post("https://yitengsze.com/a_gifhope/php/insert_charity.php",
          body: {
            "eid": idEditingController.text,
            "name": nameEditingController.text,
            "combinedStart": combinedStart,
            "combinedEnd": combinedEnd,
            "genre": selectedGenre,
            "received": received.toStringAsFixed(2),
            "target": target.toStringAsFixed(2),
            "description": descriptionEditingController.text,
            "contact": contactEditingController.text,
          }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Added SUCCESS. Please check through screen/ search bar.",
              context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.of(context).pop();
        } else {
          Toast.show("Added FAILED", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.hide();
      });
    }
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<DateTime> _selectDate(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 60)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050));

  Future<TimeOfDay> _selectTime(BuildContext context) {
    final now = DateTime.now();

    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
    );
  }

  String formatStartTimeOfDay(TimeOfDay selectedStartTime) {
    final now = new DateTime.now();
    final selectedST = DateTime(now.day, now.month, now.year,
        selectedStartTime.hour, selectedStartTime.minute);
    print(selectedST);
    return timeFormat.format(selectedST);
  }

  String formatEndTimeOfDay(TimeOfDay selectedEndTime) {
    final now = new DateTime.now();
    final selectedET = DateTime(now.day, now.month, now.year,
        selectedEndTime.hour, selectedEndTime.minute);
    print(selectedET);
    return timeFormat.format(selectedET);
  }
}

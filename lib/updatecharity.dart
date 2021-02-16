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
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

import 'charity.dart';
import 'user.dart';

class UpdateCharity extends StatefulWidget {
  final User user;
  final Charity charity;

  const UpdateCharity({Key key, this.user, this.charity}) : super(key: key);
  @override
  _UpdateCharityState createState() => _UpdateCharityState();
}

class _UpdateCharityState extends State<UpdateCharity> {
  double screenHeight, screenWidth;
  File _image;
  String pathAsset = "assets/images/camera.jpg";

  TextEditingController nameEditingController = new TextEditingController();
  TextEditingController receivedEditingController = new TextEditingController();
  TextEditingController targetEditingController = new TextEditingController();
  TextEditingController descriptionEditingController =
      new TextEditingController();
  TextEditingController contactEditingController = new TextEditingController();

  FocusNode _nameFocusNode = FocusNode();
  FocusNode _receivedFocusNode = FocusNode();
  FocusNode _targetFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _contactFocusNode = FocusNode();

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
    "COVID-19",
    "Food Security",
    "Children",
    "Education",
    "Animals",
    "Disaster"
  ];

  @override
  void initState() {
    super.initState();
    print("Edit Charity");
    nameEditingController.text = widget.charity.name; //assign current value in d/b into textfield
    receivedEditingController.text = widget.charity.received;
    targetEditingController.text = widget.charity.target;
    descriptionEditingController.text = widget.charity.description;
    contactEditingController.text = widget.charity.contact;
    startDate = convertDateFromString(widget.charity.startDateTime);
    endDate =  convertDateFromString(widget.charity.endDateTime);
    startTime = convertTimeFromString(widget.charity.startDateTime);
    endTime = convertTimeFromString(widget.charity.endDateTime);
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
        title: Text('Update Charity',
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
                              "http://yitengsze.com/a_gifhope/charityimages/${widget.charity.eid}.jpg",
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
                                    child: Text(
                                      widget.charity.eid,
                                      style: TextStyle(
                                        fontSize: 15,
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
                                      focusNode: _nameFocusNode, //current focus
                                      autofocus: true,
                                      controller: nameEditingController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (_) {
                                        fieldFocusChange(context,
                                            _nameFocusNode, _receivedFocusNode);
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                  height: 1.8,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "End Date",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  height: 1.8,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
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
                                                color: Colors.blue[100],
                                                child: Text( 
                                                  startDate,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                onPressed: () async {
                                                  final selectedStartDate =
                                                      await _selectDate(
                                                          context);

                                                  if (selectedStartDate == null)
                                                    return;
                                                  print(selectedStartDate);

                                                  setState(() {
                                                    chosenStartDate = DateTime(
                                                      selectedStartDate.day,
                                                      selectedStartDate.month,
                                                      selectedStartDate.year,
                                                    );

                                                    startDate =
                                                        dateFormat.format(
                                                            selectedStartDate);
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 70,
                                              height: 45,
                                              child: RaisedButton(
                                                color: Colors.blue[100],
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
                                                    chosenEndDate = DateTime(
                                                      selectedEndDate.day,
                                                      selectedEndDate.month,
                                                      selectedEndDate.year,
                                                    );

                                                    endDate = dateFormat.format(
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "End Time",
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
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
                                                color: Colors.blue[100],
                                                child: Text( 
                                                  startTime,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                onPressed: () async {
                                                  final selectedStartTime =
                                                      await _selectTime(
                                                          context);

                                                  if (selectedStartTime == null)
                                                    return;
                                                  print(selectedStartTime);

                                                  setState(() {
                                                    chosenStartTime = DateTime(
                                                      selectedStartTime.hour,
                                                      selectedStartTime.minute,
                                                    );

                                                    startTime =
                                                        formatStartTimeOfDay(
                                                            selectedStartTime);
                                                  });
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            SizedBox(
                                              width: 70,
                                              height: 45,
                                              child: RaisedButton(
                                                color: Colors.blue[100],
                                                child: Text(
                                                  endTime,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                                onPressed: () async {
                                                  final selectedEndTime =
                                                      await _selectTime(
                                                          context);

                                                  if (selectedEndTime == null)
                                                    return;
                                                  print(selectedEndTime);

                                                  setState(() {
                                                    chosenEndTime = DateTime(
                                                      selectedEndTime.hour,
                                                      selectedEndTime.minute,
                                                    );

                                                    endTime =
                                                        formatStartTimeOfDay(
                                                            selectedEndTime);
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
                                      hint: Text(widget.charity.genre),
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
                                      controller: descriptionEditingController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        fieldFocusChange(
                                            context,
                                            _descriptionFocusNode,
                                            _contactFocusNode);
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
                                'Update',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              color: Colors.yellow[200],
                              textColor: Colors.black,
                              elevation: 10,
                              onPressed: updateEventDialog,
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
    );
  }

  updateEventDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text("Update Event ID: " + widget.charity.eid,
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
                updateEvent();
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

  void updateEvent() async {
    if (nameEditingController.text.length < 3) {
      Toast.show("Please enter name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (receivedEditingController.text.length == 0) {
      Toast.show("Please enter received amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (targetEditingController.text.length == 0) {
      Toast.show("Please enter target amount", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (descriptionEditingController.text.length < 1) {
      Toast.show("Please enter description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (contactEditingController.text.length < 1) {
      Toast.show("Please enter contact no.", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    double received = double.parse(receivedEditingController.text);
    double target = double.parse(targetEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating event...");
    pr.show();

    String base64Image;

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());

      http.post("https://yitengsze.com/a_gifhope/php/update_event.php", body: {
        "eid": widget.charity.eid,
        "name": nameEditingController.text,
        "received": received.toStringAsFixed(2),
        "target": target.toStringAsFixed(2), //left startdate & end!
        "genre": selectedGenre,
        "description": descriptionEditingController.text,
        "contact": contactEditingController.text,
        "encoded_string": base64Image,
      }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Update success, please check through screen/ search bar.",
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

      await DefaultCacheManager().removeFile(
          'http://yitengsze.com/a_gifhope/charityimages/${widget.charity.eid}.jpg');
    } else {
      http.post("https://yitengsze.com/a_gifhope/php/update_product.php",
          body: {
            "eid": widget.charity.eid,
            "name": nameEditingController.text,
            "received": received.toStringAsFixed(2),
            "target": target.toStringAsFixed(2),
            "genre": selectedGenre,
            "description": descriptionEditingController.text,
            "contact": contactEditingController.text,
          }).then((res) {
        print(res.body);
        pr.hide();

        if (res.body.contains("success")) {
          Toast.show("Update success, please check through screen/ search bar.",
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

  convertDateFromString(String date) {
    DateTime fmtDate = DateTime.parse(date);
    print(fmtDate);
    String stringDate = dateFormat.format(fmtDate);
    return stringDate;
  }

  convertTimeFromString(String time) {
    final fmtTime = DateTime.parse(time);
    String stringTime = timeFormat.format(fmtTime);
    return stringTime;
  }
}

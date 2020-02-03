import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:warden_pijar/models/transaction.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/pages/manual_transaction_page.dart';
import 'package:warden_pijar/views/pages/qrcode_page.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:warden_pijar/views/widgets/session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

/** dict method code 
     * 1 == chekin OTS
     * 2 == checkin Booking
     * 3 == checkout
    */

class ScannerPage extends StatefulWidget {
  const ScannerPage({
    Key key,
  }) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  IconData _iconFlash = Icons.flash_off;
  var loading = false;
  //session
  SessionManager _session;
  HashMap<String, String> userData;
  String token, userID, locationID;
  //scanning
  List<Scanning> _listResponScan = [];
  List<String> splitCode;
  int methodCode;
  String qrData;
  int transStatus;
  int featureID;
  int startPrice;
  int nextPrice;
  int millis = new DateTime.now().millisecondsSinceEpoch;

  String _selectedBrandModel = "";
  String _selectedLicense = "";
  String _selectedVehicleID = "";
  String _selectedVehicleType = "";

  String payID, vouID, dura, pbill, vnom, tbill;

  @override
  Widget build(BuildContext context) {
    Widget _contentVehicle = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.motorcycle,
          color: ColorLibrary.thinFontWhite,
        ),
        Icon(
          Icons.motorcycle,
          color: ColorLibrary.thinFontWhite,
        ),
      ],
    );

    Widget _slideWidget = new Container(
      color: ColorLibrary.backgroundDark,
      child: new Column(
        children: <Widget>[
          //icon strip
          new Center(
            child: Icon(
              Icons.minimize,
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 5.0, 0.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: new Text(
                          "another way",
                          style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 30.0,
                              height: 50.0,
                              child: FlatButton(
                                child: Icon(
                                  Icons.keyboard,
                                  size: 35,
                                  color: ColorLibrary.thinFontWhite,
                                ),
                                color: ColorLibrary.primary,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  _navigateToQRCode(context);
                                },
                              ),
                            ),
                            Container(
                              height: 5.0,
                            ),
                            Text(
                              "QR Code",
                              style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Column(
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 30.0,
                              height: 50.0,
                              child: FlatButton(
                                child: Icon(
                                  Icons.library_add,
                                  size: 35,
                                  color: ColorLibrary.thinFontWhite,
                                ),
                                color: ColorLibrary.primary,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  _navigateToOtherTrans();
                                },
                              ),
                            ),
                            Container(
                              height: 5.0,
                            ),
                            Text(
                              "Other",
                              style: TextStyle(
                                  fontFamily: 'Work Sans',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      height: 28.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 2.0, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                new SizedBox(
                  width: 25.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget _cameraWidget = new Column(
      children: <Widget>[
        Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: ColorLibrary.secondary,
              borderRadius: 10.0,
              borderLength: 40.0,
              borderWidth: 5.0,
              cutOutSize: 300.0,
            ),
          ),
        ),
        Container(
          height: 150.0,
        )
      ],
    );

    Widget _compileWidget = new SlidingUpPanel(
      panel: _slideWidget,
      minHeight: 150.0,
      body: new Stack(
        children: <Widget>[
          _cameraWidget,
          Padding(
            padding: const EdgeInsets.all(23.0),
            child: Align(
              alignment: Alignment.topRight,
              child: new SizedBox(
                width: 40.0,
                height: 40.0,
                child: FloatingActionButton(
                  child: Icon(
                    _iconFlash,
                    size: 20.0,
                  ),
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    if (controller != null) {
                      controller.toggleFlash();
                      if (_isFlashOn(flashState)) {
                        setState(() {
                          flashState = flash_off;
                          _iconFlash = Icons.flash_on;
                        });
                      } else {
                        setState(() {
                          flashState = flash_on;
                          _iconFlash = Icons.flash_off;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );

    return _compileWidget;
  }

  _isFlashOn(String current) {
    return flash_on == current;
  }

  void _dialogConfirmation() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                (methodCode < 3) ? 'CHECK-IN' : 'CHECK-OUT',
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "License Number: $_selectedLicense",
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  new Text(
                    "Brand - Model: $_selectedBrandModel",
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  new Text(
                    (_selectedVehicleType == "1")
                        ? "Vehicle Type: CAR"
                        : "Vehicle Type: BIKE",
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      btnOkText: "Yes",
      btnOkOnPress: () {
        if (methodCode < 3) {
          _checkinAction();
        } else if (methodCode == 3) {
          _checkoutAction();
        }
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        controller.resumeCamera();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  void _dialogWarning() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                "Warning !",
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "There is vehicle still check-in",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () {
        controller.resumeCamera();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  Future<Null> _checkoutAction() async {
    print("masuk checkout");
    final _prefs = await SharedPreferences.getInstance();
    String url = BaseUrl.CHECKOUT;
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    token = userData['USER_TOKEN'];
    String wardenID = userData['USER_ID'];
    int pjg = qrData.length;
    String subTrans = qrData.substring(8, pjg);
    int transCode = int.parse(subTrans);

    var client = new http.Client();
    String body = '''{
        "method":"checkout", "warden_checkout_by": "$wardenID", "transaction_code": "$transCode"
      }''';

    print("body checkout $body");

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    print(response);
    final jsonObject = json.decode(response.body);
    int status = (jsonObject as Map<String, dynamic>)['status'];

    if (response.statusCode == 200) {
      if (status == 200) {
        Fluttertoast.showToast(
          msg: "Checkout Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Oops, Something wrong",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Oops, Something wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
    controller.resumeCamera();
  }

  Future<Null> _checkinAction() async {
    final _prefs = await SharedPreferences.getInstance();
    String url = BaseUrl.CHECKIN;
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    token = userData['USER_TOKEN'];
    String wardenID = userData['USER_ID'];
    String locationID = userData['USER_LOCATION'];

    var client = new http.Client();
    String body = '';
    int pjg = qrData.length;

    if (methodCode == 2) {
      // checkin booking
      var substring = qrData.substring(8, pjg);
      int transCode = int.parse(substring);

      body = '''{"method":"checkinBooking",
        "warden_checkin_by": "$wardenID", "transaction_code":"$transCode"
      }''';
      print('body checkinBooking $body');
    } else if (methodCode == 1) {
      // checkin ots
      var substr1 = qrData.substring(1, 8);
      var substr2 = qrData.substring(8, 15);
      var substr3 = qrData.substring(15, 16);
      var substr4 = qrData.substring(16, 17);
      int custID = int.parse(substr1);
      int vehID = int.parse(substr2);
      int vehType = int.parse(substr3);
      int featType = int.parse(substr4);
      print('qrData $qrData');
      String transCode =
          '$custID$vehID$vehType$featureID$featType$locationID$millis';

      body = '''{"method":"checkinOTS",
        "transaction_code":"$transCode", "user_id":"$custID", "vehicle_id":"$vehID", "vehicle_type_id":"$vehType",
        "feature_id":"$featureID", "feature_type_id":"$featType", "location_id":"$locationID", "start_price":"$startPrice",
        "next_price":"$nextPrice", "warden_checkin_by": "$wardenID"
      }''';

      print('body checkinOTS $body');
    }

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Checkin Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Oops, Something wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    controller.resumeCamera();
  }

  Future<Null> _checkScanning() async {
    final _prefs = await SharedPreferences.getInstance();
    String url = BaseUrl.SCANNING;
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    token = userData['USER_TOKEN'];
    locationID = userData['USER_LOCATION'];

    var pjg = qrData.length;

    var client = new http.Client();
    String body;

    var substr1 = qrData.substring(1, 8);
    var substr2 = qrData.substring(8, 15);
    var substr3 = qrData.substring(15, 16);
    var substr4 = qrData.substring(16, 17);
    int custID = int.parse(substr1);
    int vehID = int.parse(substr2);
    int vehiType = int.parse(substr3);
    int featType = int.parse(substr4);
    body =
        '''{"method": "scan", "user_id": "$custID", "vehicle_id":"$vehID", "feature_type_id":"$featType", "location_id":"$locationID",
        "include": ["vehicle_id", "vehicle_brand_id", "vehicle_model_id"]}''';

    print(body);

    setState(() {
      loading = true;
    });
    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);

      if (mounted) {
        setState(() {
          for (Map i in jsonObject['result']) {
            _listResponScan.add(Scanning.fromJson(i));
          }

          _selectedVehicleID = _listResponScan[0].vehicleID.toString();
          _selectedVehicleType = _listResponScan[0].vehicleTypeID.toString();
          _selectedBrandModel = _listResponScan[0].brandName +
              ' - ' +
              _listResponScan[0].modelName;
          _selectedLicense = _listResponScan[0].vehicleLicense;
          featureID = _listResponScan[0].featureID;
          startPrice = _listResponScan[0].startPrice;
          nextPrice = _listResponScan[0].nextPrice;

          loading = false;
        });
      }

      int code = (jsonObject as Map<String, dynamic>)['code'];
      if (code == 1) {
        _dialogConfirmation();
      } else {
        _dialogWarning();
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        controller.pauseCamera();
        if (scanData.isNotEmpty) {
          qrData = scanData;
          methodCode = int.parse(scanData.substring(0, 1));

          if (methodCode < 3) {
            _checkScanning();
          } else if (methodCode == 3) {
            print('methodCode $methodCode');
            print('scanData $scanData');
            _dialogConfirmation();
          } else {
            controller.resumeCamera();
            Fluttertoast.showToast(
              msg: "Oops, Something wrong",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        } else {
          controller.resumeCamera();
          Fluttertoast.showToast(
            msg: "Oops, Something wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      });
    });
  }

  _navigateToQRCode(BuildContext context) async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String wardenID = userData['USER_ID'];
    String locationID = userData['USER_LOCATION'];

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new QrcodePage(wardenID, locationID),
      ),
    );
  }

  _navigateToOtherTrans() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ManualTransactionPage()));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

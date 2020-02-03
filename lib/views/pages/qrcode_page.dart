import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';

class QrcodePage extends StatelessWidget {
  final String userID;
  final String locationID;
  const QrcodePage(this.userID, this.locationID);
  
  @override
  Widget build(BuildContext context) {
    int nol = 0;
    String nolUser = '';
    String nolLoca = '';

    for (var i = userID.length; i < 7; i++) {
      nolUser+= nol.toString();
    }

    for (var i = locationID.length; i < 7; i++) {
      nolLoca+= nol.toString();
    }

    Widget _qrcode = new Container(
      width: 230.0,
      height: 230.0,
      child: QrImage(
        data: '${nolUser+userID}${nolLoca+locationID}',
        version: 1,
      ),
    );

    Widget _compile = new Container(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Your Check-In Code",
            style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          new Text(
            "Show this code to the user for check-in",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          _qrcode,
          new Text(
            '${nolUser+userID}${nolLoca+locationID}',
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 20),
          ),
          Container(
            height: 5.0,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        iconTheme: IconThemeData(color: ColorLibrary.regularFontWhite),
        title: Text(
          "Check-In",
          style: TextStyle(
              fontFamily: 'Work Sans', color: ColorLibrary.regularFontWhite),
        ),
      ),
      body: _compile,
    );
  }
}

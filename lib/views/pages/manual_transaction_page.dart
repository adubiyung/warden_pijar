import 'package:flutter/material.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';

class ManualTransactionPage extends StatefulWidget {
  @override
  _ManualTransactionPageState createState() => _ManualTransactionPageState();
}

class _ManualTransactionPageState extends State<ManualTransactionPage> {
  int _typeIDValue = 1;
  var licenseCont = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          "Manual Transaction",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _typeIDValue = 2;
                      // _fetchData(_typeIDValue.toString());
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: _typeIDValue == 2
                          ? Border.all(width: 1.0, color: ColorLibrary.primary)
                          : Border.all(
                              width: 0.0, color: ColorLibrary.thinFontWhite),
                      borderRadius: BorderRadius.circular(60.0),
                      color: _typeIDValue == 2
                          ? ColorLibrary.secondary
                          : ColorLibrary.thinFontWhite,
                    ),
                    child: _typeIDValue == 2
                        ? Icon(
                            Icons.motorcycle,
                            size: 40,
                            color: ColorLibrary.thinFontBlack,
                          )
                        : Icon(
                            Icons.motorcycle,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _typeIDValue = 1;
                      // _fetchData(_typeIDValue.toString());
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: _typeIDValue == 1
                          ? Border.all(width: 1.0, color: ColorLibrary.primary)
                          : Border.all(
                              width: 0.0, color: ColorLibrary.thinFontWhite),
                      borderRadius: BorderRadius.circular(60.0),
                      color: _typeIDValue == 1
                          ? ColorLibrary.secondary
                          : ColorLibrary.thinFontWhite,
                    ),
                    child: _typeIDValue == 1
                        ? Icon(
                            Icons.directions_car,
                            size: 40,
                            color: ColorLibrary.thinFontBlack,
                          )
                        : Icon(
                            Icons.directions_car,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              style: TextStyle(fontFamily: 'Work Sans'),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontFamily: 'Work Sans'),
                  labelText: "License Number"),
              controller: licenseCont,
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              color: ColorLibrary.secondary,
              child: Text(
                "Print Ticket",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:warden_pijar/services/api.dart';
import 'package:warden_pijar/views/pages/otp_page.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var numberController = TextEditingController();

    void moveToOTP(String number, String otp) {
      Navigator.of(context).push(PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) =>
            new OtpPage(phoneNumber: number, otpNumber: otp),
      ));
    }

    sendOTP(String hpOtp, String number, String otp) async {
      String msg =
          "Pijar - JANGAN MEMBERIKAN KODE INI KE SIAPAPUN. Kode verifikasi (OTP) Anda adalah $otp.";
      String url =
          "https://secure.gosmsgateway.com/api/Send.php?username=sigmatelkom&mobile=$number&message=$msg&password=gosms3e35fg";
      print(url);
      var client = new http.Client();
      var response = await client.get(url);

      if (response.statusCode == 200) {
        moveToOTP(hpOtp, otp.toString());
      } else {
        print("something wrong ${response.statusCode}");
      }
    }

    void _dialogRegister(String number) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "You seem to be new",
              style: TextStyle(
                  fontFamily: 'Work Sans', fontWeight: FontWeight.w700),
            ),
            content: new Text(
              "This number $number has not been registered on Pijar Warden.\nPlease contact customer service for more information.",
              style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w300,
                  fontSize: 12),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "OK",
                  style: TextStyle(fontFamily: 'Work Sans'),
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

    authNumber(String number) async {
      String phoneNumber;
      String nomor;
      if (number[0] == '0') {
        nomor = number;
        number = number.substring(1, number.length);
        phoneNumber = "62$number";
      } else if (number[0] == '+') {
        nomor = '0' + number.substring(3, number.length);
      }

      var client = new http.Client();
      // variable request berfungsi untuk mengirimkan data dengan method post
      try {
        var response = await client.post(BaseUrl.LOGIN_AUTH,
            body: '{"user_phone": "$phoneNumber", "method": "auth_number"}');

        var jsonObject = json.decode(response.body);
        dynamic otp = jsonObject['data'];
        String message = jsonObject['message'];
        int status = jsonObject['status'];
        print('object $phoneNumber');
        print('object ${response.body}');

        if (status == 200) {
          sendOTP(phoneNumber, nomor, otp.toString());
        } else if (status == 204) {
          _dialogRegister(phoneNumber);
        } else {
          print(message);
        }
      } finally {
        client.close();
      }
    }

    return new Scaffold(
      body: new Container(
        color: ColorLibrary.primary,
        width: MediaQuery.of(context).size.width,
        child: new Padding(
          padding: EdgeInsets.all(25.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    new Text(
                      "PIJAR",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: ColorLibrary.regularFontWhite,
                          fontSize: 25),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    new Text(
                      "Parkir Jalan Raya",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: ColorLibrary.regularFontWhite,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    new TextField(
                      controller: numberController,
                      cursorColor: ColorLibrary.thinFontWhite,
                      obscureText: false,
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: ColorLibrary.regularFontWhite),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: ColorLibrary.thinFontWhite,
                        ),
                        hintText: "+62 \t Your Phone Number",
                        hintStyle: TextStyle(
                            fontFamily: 'Work Sans',
                            color: ColorLibrary.thinFontWhite),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorLibrary.thinFontWhite),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorLibrary.primaryDark),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    new ButtonTheme(
                      minWidth: 250.0,
                      child: new RaisedButton(
                        color: ColorLibrary.secondary,
                        child: new Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w700,
                            color: ColorLibrary.regularFontWhite,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: ColorLibrary.secondary),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        onPressed: () {
                          authNumber(numberController.text);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

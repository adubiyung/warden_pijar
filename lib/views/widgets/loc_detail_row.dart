import 'package:flutter/material.dart';
import 'package:warden_pijar/models/location.dart';
import 'package:warden_pijar/views/pages/lot_page.dart';
import 'package:warden_pijar/views/widgets/color_library.dart';

class LocDetailRow extends StatelessWidget {
  final LocationDetail _model;
  LocDetailRow(this._model);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10.0, left: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: ColorLibrary.primary),
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: new ListTile(
        leading: Container(
          height: 25.0,
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: ColorLibrary.primary),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.compare_arrows,
                color: ColorLibrary.thinFontBlack,
              ),
            ],
          ),
        ),
        title: Text(
          _model.detailLocName,
          style:
              TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w500),
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Icon(Icons.arrow_forward_ios),
        ),
        onTap: () {
          _moveToSelectLot(context, _model.locationID.toString());
        },
      ),
    );
  }
}

void _moveToSelectLot(BuildContext context, String id) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => new LotPage(locationID: id,),
    ),
  );
}

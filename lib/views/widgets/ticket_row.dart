import 'package:flutter/material.dart';
import 'package:warden_pijar/models/transaction.dart';
import 'package:warden_pijar/views/pages/detail_ticket_page.dart';

import 'color_library.dart';

class TicketRow extends StatelessWidget {
  final DataTransaction model;
  TicketRow(this.model);

  @override
  Widget build(BuildContext context) {
    void _modalBottomSheet(context) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: ColorLibrary.secondary,
        elevation: 0.0,
        context: context,
        builder: (BuildContext cont) {
          return DetailTicketPage(modelTrans: model);
        },
      );
    }

    final _ticketDot = new ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 30.0),
      leading: new Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: ColorLibrary.backgroundDark),
      ),
      trailing: new Container(
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ColorLibrary.backgroundDark,
          boxShadow: <BoxShadow>[new BoxShadow(color: Colors.transparent)],
        ),
      ),
      onTap: () {
        _modalBottomSheet(context);
      },
    );

    final _ticketThumbnailIcon = new ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 22.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
              right:
                  BorderSide(width: 2.0, color: ColorLibrary.backgroundDark)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.drive_eta,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              model.vehicle.vehicleLicense,
              style: TextStyle(color: Colors.white, fontSize: 10),
            )
          ],
        ),
      ),
    );

    final baseTextStyle = const TextStyle(fontFamily: 'Work Sans');
    final regularTextStyle = baseTextStyle.copyWith(
        color: const Color(0xffb6b2df),
        fontSize: 9.0,
        fontWeight: FontWeight.w400);
    final subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 10.0);
    final headerTextStyle = baseTextStyle.copyWith(
        color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w600);

    final _ticketCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(90.0, 16.0, 16.0, 16.0),
      constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(model.location.locationName, style: headerTextStyle),
          new Container(height: 10.0),
          // new Text(
          //     model.location.locationAddress +
          //         " " +
          //         model.location.locationCity,
          //     style: subHeaderTextStyle),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: MediaQuery.of(context).size.width - 170.0,
              color: new Color(0xff00c6ff)),
          new Row(
            children: <Widget>[
              Container(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  (model.checkinTime == null) ? '' : model.checkinTime.substring(0, 10),
                  style: regularTextStyle,
                ),
              ),
              Container(
                width: 8.0,
              ),
              Expanded(
                child: Text(
                  model.featureType.featureName,
                  style: regularTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final _ticketCard = new Container(
      child: _ticketCardContent,
      height: 124.0,
      margin: new EdgeInsets.only(left: 10.0, right: 10.0),
      decoration: new BoxDecoration(
        color: ColorLibrary.primary,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.transparent,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 14.0,
        ),
        child: new Stack(
          children: <Widget>[_ticketCard, _ticketThumbnailIcon, _ticketDot],
        ));
  }
}

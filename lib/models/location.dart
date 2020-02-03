class LocationDetail {
  final int locationID;
  final int detailLocID;
  final String detailLocName;
  final int wayType;
  final int totalSide;

  LocationDetail({
    this.locationID,
    this.detailLocID,
    this.detailLocName,
    this.wayType,
    this.totalSide,
  });

  factory LocationDetail.fromJson(Map<String, dynamic> parsedJson) {
    return LocationDetail(
      locationID: parsedJson['location_id'],
      detailLocID: parsedJson['detail_location_id'],
      detailLocName: parsedJson['detail_location_name'],
      wayType: parsedJson['way_type'],
      totalSide: parsedJson['total_side'],
    );
  }
}

class LocationLot {
  final int lotID;
  final String lotLocationUUID;
  int detailLotID;
  final int detailLocationID;
  final String detailLocationName;
  final int wayType;
  final int locationID;
  final int sideID;
  final bool isBooking;
  bool isAvailable;
  final Function onChange;

  LocationLot({
    this.lotID,
    this.lotLocationUUID,
    this.detailLotID,
    this.detailLocationID,
    this.detailLocationName,
    this.wayType,
    this.locationID,
    this.sideID,
    this.isBooking,
    this.isAvailable,
    this.onChange,
  });

  factory LocationLot.fromJson(Map<String, dynamic> parsedJson) {
    return LocationLot(
      lotID: parsedJson['lot_id'],
      lotLocationUUID: parsedJson['lot_location_uuid'],
      detailLotID: parsedJson['detail_lot_id'],
      detailLocationID: parsedJson['detail_location_id'],
      detailLocationName: parsedJson['detail_location_name'],
      wayType: parsedJson['way_type'],
      locationID: parsedJson['location_id'],
      sideID: parsedJson['side_id'],
      isBooking: parsedJson['is_booking'],
      isAvailable: parsedJson['is_available'],
    );
  }
}

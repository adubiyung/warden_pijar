class FeatureType {
  final int featureTypeID;
  final String featureName;
  final String featureDesc;

  FeatureType({this.featureTypeID, this.featureName, this.featureDesc});

  factory FeatureType.fromJson(Map<String, dynamic> parsedJson) {
    return FeatureType(
      featureTypeID: parsedJson['feature_type_id'],
      featureName: parsedJson['feature_name'],
      featureDesc: parsedJson['feature_desc'],
    );
  }
}
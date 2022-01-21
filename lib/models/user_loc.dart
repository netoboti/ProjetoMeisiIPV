class UserLocation {
  final int id;
  final String locDateTime;
  final double userLat;
  final double userLon;
  final String vagas;

  UserLocation({this.id, this.locDateTime, this.userLat, this.userLon, this.vagas});

  Map<String, dynamic> toMap() {
    return {
      'locDateTime': locDateTime,
      'userLat': userLat,
      'userLon': userLon,
      'vagas': vagas
    };
  }

  @override
  String toString() {
    return '$locDateTime,$userLat,$userLon,$id,$vagas';
  }
}

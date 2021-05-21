class Record {
  int id;
  double distance;
  double totalTime;
  double speed;
  String dateTime;

  Record({ this.id, this.distance, this.totalTime, this.speed, this.dateTime });

  Record.fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.distance = map["distance"];
    this.totalTime = map["totalTime"];
    this.speed = map["speed"];
    this.dateTime = map["dateTime"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'distance': distance,
      'totalTime': totalTime,
      'speed': speed,
      'dateTime': dateTime,
    };
  }

  @override
  String toString() {
    return 'Record{id: $id, distance: $distance, totalTime: $totalTime, speed: $speed, dateTime: $dateTime}';
  }
}
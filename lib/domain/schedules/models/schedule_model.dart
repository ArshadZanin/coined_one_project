class ScheduleModel {
  String? id;
  String? name;
  String? startTime;
  String? endTime;
  String? date;

  ScheduleModel({
    this.id,
    this.name,
    this.startTime,
    this.endTime,
    this.date,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map.containsKey('_id') ? map['_id'] : null,
      name: map.containsKey('name') ? map['name'] : null,
      startTime: map.containsKey('startTime') ? map['startTime'] : null,
      endTime: map.containsKey('endTime') ? map['endTime'] : null,
      date: map.containsKey('date') ? map['date'] : null,
    );
  }

  ScheduleModel copyWith({
    String? id,
    String? name,
    String? startTime,
    String? endTime,
    String? date,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      date: date ?? this.date,
    );
  }
}

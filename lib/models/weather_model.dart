class WeatherModel {
  int id;
  String? dateRecorded, dateSeen, timeSeen, country, description;
  double? humidity, temperature, tempMin, tempMax, tempFeelsLike;

  WeatherModel({
    required this.id,
    required this.dateRecorded,
    required this.dateSeen,
    required this.timeSeen,
    required this.country,
    required this.description,
    required this.humidity,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.tempFeelsLike
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'daterecorded': dateRecorded,
      'dateseen': dateSeen,
      'timeseen': timeSeen,
      'country': country,
      'description': description,
      'humidity': humidity,
      'temperature': temperature,
      'tempmin': tempMin,
      'tempmax': tempMax,
      'tempfeelslike': tempFeelsLike
    };
    return map;
  }

  List<Object?> toList() {
    return [
      id,
      dateRecorded,
      dateSeen,
      timeSeen,
      country,
      description,
      humidity,
      temperature,
      tempMin,
      tempMax,
      tempFeelsLike
    ];
  }
}
class WeatherModel {
  String? dateRecorded, date, country, weather;
  double? humidity, temperature, tempMin, tempMax, tempFeelsLike;

  WeatherModel({
    required this.dateRecorded,
    required this.date,
    required this.country,
    required this.weather,
    required this.humidity,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.tempFeelsLike
  });

  Map<String, dynamic> toMap() {
    return {
      'daterecorded': dateRecorded,
      'date': date,
      'country': country,
      'weather': weather,
      'humidity': humidity,
      'temperature': temperature,
      'tempmin': tempMin,
      'tempmax': tempMax,
      'tempfeelslike': tempFeelsLike
    };
  }
}
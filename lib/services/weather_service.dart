import 'package:fitness/services/db_service.dart';
import 'package:weather/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherService {
  WeatherFactory? wf;

  WeatherService() {
    if (dotenv.env['API_KEY'] != null) {
      wf = WeatherFactory(dotenv.env['API_KEY'] ?? "", language: Language.ENGLISH);
    }
  }

  Future<List<WeatherModel>>? getWeather() async {
    List<WeatherModel>? dbWeatherList = await DbService().getWeather(DateTime.now());
    if (dbWeatherList.isNotEmpty) return dbWeatherList;

    List<Weather>? apiWeatherList = await wf?.fiveDayForecastByCityName("Toronto");
    List<WeatherModel> weatherList = [];

    for (int index = 0; index < (apiWeatherList?.length ?? 0); index++) {
      Weather? weather = apiWeatherList?.elementAt(index);
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String dateRecorded = formatter.format(DateTime.now());

      weatherList.add(WeatherModel(
        dateRecorded: dateRecorded,
        date: weather?.date?.toIso8601String(),
        country: weather?.country,
        weather: weather?.weatherDescription,
        temperature: weather?.temperature?.celsius,
        humidity: weather?.humidity,
        tempMin: weather?.tempMin?.celsius,
        tempMax: weather?.tempMax?.celsius,
        tempFeelsLike: weather?.tempFeelsLike?.celsius
      ));
    }

    return weatherList;
  }
}
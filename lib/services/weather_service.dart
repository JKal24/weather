import 'package:fitness/services/db_service.dart';
import 'package:weather/weather.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherService {
  WeatherFactory? wf;
  final DbService dbService = DbService();

  WeatherService() {
    if (dotenv.env['API_KEY'] != null) {
      wf = WeatherFactory(dotenv.env['API_KEY'] ?? "", language: Language.ENGLISH);
    }
  }

  Future<WeatherModel?> getTodaysWeather() async {
    await dbService.init();
    WeatherModel? model = await dbService.getWeather(DateTime.now());

    if (model == null) {
      List<WeatherModel>? models = await getNext5DaysWeather();

      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String date = formatter.format(DateTime.now());

      for (int index = 0; index < (models?.length ?? 0); index++) {
        WeatherModel? nextModel = models?.elementAt(index);
        
        if (nextModel != null && nextModel.dateSeen == date && nextModel.dateRecorded == date) return nextModel;
      }
    }

    return model;
  }

  Future<List<WeatherModel>>? getNext5DaysWeather() async {
    await dbService.init();
    List<WeatherModel>? dbWeatherList = await dbService.getWeatherList(DateTime.now());
    if (dbWeatherList.isNotEmpty) return dbWeatherList;

    List<Weather>? apiWeatherList = await wf?.fiveDayForecastByCityName("Toronto");
    List<WeatherModel> weatherList = [];

    DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    String dateRecorded = dateFormatter.format(DateTime.now());

    DateFormat timeFormatter = DateFormat('hh:mm');

    for (int index = 0; index < (apiWeatherList?.length ?? 0); index++) {
      Weather? weather = apiWeatherList?.elementAt(index);

      WeatherModel model = WeatherModel(
        id: index,
        dateRecorded: dateRecorded,
        dateSeen: dateFormatter.format(weather?.date ?? DateTime.now()),
        timeSeen: timeFormatter.format(weather?.date ?? DateTime.now()),
        country: weather?.country,
        description: weather?.weatherDescription,
        temperature: weather?.temperature?.celsius,
        humidity: weather?.humidity,
        tempMin: double.parse(weather?.tempMin?.celsius?.toStringAsFixed(1) ?? "0.0"),
        tempMax: double.parse(weather?.tempMax?.celsius?.toStringAsFixed(1) ?? "0.0"),
        tempFeelsLike: double.parse(weather?.tempFeelsLike?.celsius?.toStringAsFixed(1) ?? "0.0")
      );
      weatherList.add(model);

      await dbService.addWeather(model);
    }

    return weatherList;
  }
}
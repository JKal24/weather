import 'package:fitness/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

class DbService {
  late MySqlConnection database;

  Future<void> init() async {
    var settings = ConnectionSettings(
      host: 'localhost', 
      port: 3306,
      user: 'root',
      password: 'root',
      db: 'weather'
    );

    database = await MySqlConnection.connect(settings);
  }

  Future<void> addWeather(WeatherModel weatherModel) async {
    await database.query("insert into weather (id, daterecorded, date, time, country, description, humidity, temperature, tempmin, tempmax, tempfeelslike) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", weatherModel.toList());
  }

  Future<WeatherModel?> getWeather(DateTime dateTime) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String date = formatter.format(dateTime);

    Results results = await database.query("select * from weather where date = ?", [date]);

    for (var row in results) {
      WeatherModel model = WeatherModel(
        id: row[0],
        dateRecorded: row[1],
        dateSeen: row[2],
        timeSeen: row[3],
        country: row[4],
        description: row[5],
        humidity: row[6],
        temperature: row[7],
        tempMin: row[8],
        tempMax: row[9],
        tempFeelsLike: row[10]
      );
      return model;
    }
    return null;
  }

  Future<List<WeatherModel>> getWeatherList(DateTime dateTime) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateRecorded = formatter.format(dateTime);

    Results results = await database.query("select * from weather where daterecorded = ?", [dateRecorded]);
    List<WeatherModel> weathers = [];

    for (var row in results) {
      WeatherModel model = WeatherModel(
        id: row[0],
        dateRecorded: row[1],
        dateSeen: row[2],
        timeSeen: row[3],
        country: row[4],
        description: row[5],
        humidity: row[6],
        temperature: row[7],
        tempMin: row[8],
        tempMax: row[9],
        tempFeelsLike: row[10]
      );
      weathers.add(model);
    }

    return weathers;
  }
}
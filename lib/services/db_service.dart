import 'package:fitness/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  Database? database;

  Future<void> init() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'weather'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE weathers(id INTEGER PRIMARY KEY AUTOINCREMENT, daterecorded TEXT, dateseen TEXT, timeseen TEXT, country TEXT, description VARCHAR(255), humidity DOUBLE, temperature DOUBLE, tempmin DOUBLE, tempmax DOUBLE, tempfeelslike DOUBLE)',
        );
      },
      version: 4,
    );
  }

  Future<void> addWeather(WeatherModel weatherModel) async {
    await database?.insert('weathers', weatherModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<WeatherModel?> getWeather(DateTime dateTime) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String date = formatter.format(dateTime);

    final List<Map<String, dynamic>>? maps = await database?.query('weathers', where: 'date = ?', whereArgs: [date]);
    for (int index = 0; index < (maps?.length ?? 0); index++) {
      Map<String, dynamic>? map = maps?.elementAt(index);

      if (map != null) {
        WeatherModel model = WeatherModel(
          id: map["id"],
          dateRecorded: map["daterecorded"],
          dateSeen: map["dateseen"],
          timeSeen: map["timeseen"],
          country: map["country"],
          description: map["description"],
          humidity: map["humidity"],
          temperature: map["temperature"],
          tempMin: map["tempmin"],
          tempMax: map["tempmax"],
          tempFeelsLike: map["tempfeelslike"]
        );
        return model;
      }
    }
    return null;
  }

  Future<List<WeatherModel>> getWeatherList(DateTime dateTime) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateRecorded = formatter.format(dateTime);

    final List<Map<String, dynamic>>? maps = await database?.query('weathers', where: 'daterecorded = ?', whereArgs: [dateRecorded]);
    List<WeatherModel> weathers = [];

    for (int index = 0; index < (maps?.length ?? 0); index++) {
      Map<String, dynamic>? map = maps?.elementAt(index);

      if (map != null) {
        weathers.add(WeatherModel(
          id: map["id"],
          dateRecorded: map["daterecorded"],
          dateSeen: map["dateseen"],
          timeSeen: map["timeseen"],
          country: map["country"],
          description: map["description"],
          humidity: map["humidity"],
          temperature: map["temperature"],
          tempMin: map["tempmin"],
          tempMax: map["tempmax"],
          tempFeelsLike: map["tempfeelslike"]
        ));
      }
    }

    return weathers;
  }
}
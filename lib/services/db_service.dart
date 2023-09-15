import 'package:fitness/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbService {
  Database? database;

  DbService() {
    _getDatabase();
  }

  _getDatabase() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'weather.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE weather(id INTEGER PRIMARY KEY, daterecorded TEXT, date TEXT, country TEXT, weather VARCHAR(255), humidity DOUBLE, temperature DOUBLE, tempmin DOUBLE, tempmax DOUBLE, tempfeelslike DOUBLE)',
        );
      },
      version: 1,
    );
  }

  Future<void> addWeather(WeatherModel weatherModel) async {
    await database?.insert('weather', weatherModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WeatherModel>> getWeather(DateTime dateTime) async {
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateRecorded = formatter.format(dateTime);

    final List<Map<String, dynamic>>? maps = await database?.query('weather', where: 'daterecorded = ?', whereArgs: [dateRecorded]);
    List<WeatherModel> weathers = [];

    for (int index = 0; index < (maps?.length ?? 0); index++) {
      Map<String, dynamic>? map = maps?.elementAt(index);

      if (map != null) {
        weathers.add(WeatherModel(
          dateRecorded: map["daterecorded"],
          date: map["date"],
          country: map["country"],
          weather: map["weather"],
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
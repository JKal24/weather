import 'package:fitness/models/weather_model.dart';
import 'package:fitness/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HomeUI extends StatelessWidget {
  const HomeUI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff303644),
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String dateToday = DateFormat('MMMM d, y').format(DateTime.now());
  List<WeatherModel> weatherList = [];
  List<WeatherModel> weatherListPerDay = [];

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
  }

  Future<void> _getInitialInfo() async {
    List<WeatherModel> newWeatherList = (await WeatherService().getNext5DaysWeather() ?? []);
    List<WeatherModel> newWeatherListPerDay = [];

    Map<String, List<WeatherModel>> weathersPerDay = {};

    for (WeatherModel model in newWeatherList) {
      if (!weathersPerDay.containsKey(model.dateSeen)) {
        weathersPerDay[model.dateSeen ?? ""] = [];
      }
      weathersPerDay[model.dateSeen]?.add(model);
    }

    weathersPerDay.forEach((key, value) {
      double count = 0.0;
      double currentTemp = 0.0;
      double humidity = 0.0;

      Map<String, int> weatherCounts = {};

      for (WeatherModel model in value) {
        count++;
        currentTemp += model.temperature ?? 0.0;
        humidity += model.humidity ?? 0.0;

        if (!weatherCounts.containsKey(model.description)) weatherCounts[model.description ?? ""] = 0;
        int prevWeatherCount = weatherCounts[model.description ?? ""] ?? 0;
        weatherCounts[model.description ?? ""] = prevWeatherCount + 1;
      }

      if (value.isNotEmpty) {
        WeatherModel dailyModel = value[0];
        dailyModel.temperature = double.parse((currentTemp / count).toStringAsFixed(1));
        dailyModel.humidity = double.parse((humidity / count).toStringAsFixed(1));

        String weather = "";
        int countWeather = 0;
        for (String recordedWeather in weatherCounts.keys) {
          if ((weatherCounts[recordedWeather] ?? 0) > countWeather) {
            countWeather = weatherCounts[recordedWeather] ?? 0;
            weather = recordedWeather;
          }
        }

        dailyModel.description = weather;
        newWeatherListPerDay.add(dailyModel);
      }
    });

    setState(() {
      weatherList = newWeatherList;
      weatherListPerDay = newWeatherListPerDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.blue,
      body: Column (
        children: [
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  dateToday,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
                Text(
                  (weatherList.isNotEmpty) ? "${weatherList[0].temperature}℃" : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52
                  ),
                ),
                Text(
                  (weatherList.isNotEmpty) ? "${weatherList[0].tempMin}℃/${weatherList[0].tempMax}℃ Feels like ${weatherList[0].tempFeelsLike}℃" : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
                Text(
                  (weatherList.isNotEmpty) ? "${weatherList[0].description?[0].toUpperCase()}${weatherList[0].description?.substring(1)}" : '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 110,
                  width: 400,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightBlue
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return weatherList.isNotEmpty ?
                      (
                        Column(
                          children: [
                            Text(
                              "${weatherList[index].dateSeen?.split("-")[1]}/${weatherList[index].dateSeen?.split("-")[2]}, ${weatherList[index].timeSeen}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              "${weatherList[index].temperature}℃",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              "${weatherList[index].humidity}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              "${weatherList[index].description}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            )
                          ]
                        )
                      ) :
                      (
                        const SizedBox(height: 0, width: 0)
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 20,
                    )
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 160,
                  width: 400,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.lightBlue
                  ),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: weatherListPerDay.length,
                    itemBuilder: (context, index) {
                      return weatherList.isNotEmpty ?
                      (
                        Column(
                          children: [
                            Text(
                              "${weatherListPerDay[index].dateSeen?.split("-")[1]}/${weatherListPerDay[index].dateSeen?.split("-")[2]}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              (weatherListPerDay.isNotEmpty) ? "${weatherListPerDay[index].temperature}℃" : '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32
                              ),
                            ),
                            Text(
                              (weatherListPerDay.isNotEmpty) ? "${weatherListPerDay[index].tempMin}℃/${weatherListPerDay[index].tempMax}℃" : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              "${weatherListPerDay[index].humidity}%",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            ),
                            Text(
                              (weatherListPerDay.isNotEmpty) ? "${weatherListPerDay[index].description?[0].toUpperCase()}${weatherListPerDay[index].description?.substring(1)}" : '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 16
                              ),
                            )
                          ]
                        )
                      ) :
                      (
                        const SizedBox(height: 0, width: 0)
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 20,
                    )
                  )
                )
              ]
            ),
          )
        ]
      )
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: const Text(
      "Toronto",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    centerTitle: true,
    leading: Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffF7F8F8),
        borderRadius: BorderRadius.circular(10)
      ),
      child: SvgPicture.asset('assets/icons/Arrow - Left 2.svg'),
    ),
    actions: [
      GestureDetector(
        onTap: () {  },
        child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        width: 40,
        decoration: BoxDecoration(
          color: const Color(0xffF7F8F8),
          borderRadius: BorderRadius.circular(10)
        ),
        child: SvgPicture.asset('assets/icons/dots.svg'),
        )
      )
    ],
  );
}

Container _searchBar() {
  return Container(
    margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: const Color(0xff1D1617).withOpacity(0.11),
          blurRadius: 40,
          spreadRadius: 0.0
        )
      ]
    ),
    child: TextField(
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        hintText: 'Search...',
        hintStyle: const TextStyle(
          color: Color(0xffDDDADA),
          fontSize: 14
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset('assets/icons/Search.svg')
        ),
        suffixIcon: Container(
          width: 100,
          child: IntrinsicHeight(child: 
            Row (
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const VerticalDivider(
                  color: Colors.black,
                  indent: 10,
                  endIndent: 10,
                  thickness: 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Filter.svg')
                )
              ]
            )
          )
        ) ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none
        )
      ),
    )
  );
}

Container _title() {
  return Container(
    margin: const EdgeInsets.only(top: 40),
    child: const Column (
      children: [
        Text(
          'Weather',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600
          )
        )
      ]
    )
  );
}
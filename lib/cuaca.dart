import 'package:clambi/forecast/forecast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:clambi/Api/parsing.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

class MyCuaca extends StatefulWidget {
  @override
  _MyCuacaState createState() => _MyCuacaState();
}

class _MyCuacaState extends State<MyCuaca> {
  //Api Request
  late Future<Welcome> _futureWelcome;
  String link =
      'http://api.openweathermap.org/data/2.5/weather?q=pasuruan&appid=3c95727e876f0dbb3def499ea46fb708';

  Future<Welcome> fetchWelcome() async {
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      return Welcome.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data Cuaca');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureWelcome = fetchWelcome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("image/wp2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Welcome>(
              future: _futureWelcome,
              builder: (context, snapshot) {
                var state = snapshot.connectionState;
                if (state != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasData) {
                    return Cuaca(
                      name: snapshot.data!.name,
                      coord: snapshot.data!.coord,
                      suhu: snapshot.data!.main,
                      weather: snapshot.data!.weather,
                      wind: snapshot.data!.wind,
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("${snapshot.error}"));
                  } else {
                    return Text('');
                  }
                }
              }),
        ),
      ),
    );
  }
}

class Cuaca extends StatelessWidget {
  final String name;
  final Coord coord;
  final Main suhu;
  final Wind wind;
  final List<Weather> weather;

  const Cuaca(
      {Key? key,
      required this.name,
      required this.coord,
      required this.suhu,
      required this.wind,
      required this.weather})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? suhuC;
    suhuC = suhu.temp - 273;
    String suhuC_ = suhuC.toStringAsFixed(0);
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MMMM-yyyy');
    String formattedDate = formatter.format(now);

    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "Today",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              formattedDate,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: Colors.white,
                size: 15.0,
              ),
              Text(
                '  ${coord.lat} ',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              Text(
                "  -  ${coord.lon}'",
                style: TextStyle(color: Colors.white, fontSize: 13),
              )
            ],
          ),
          SizedBox(
            height: 90,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "${suhuC_}°C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "feels like ${(suhu.feelsLike - 273).toStringAsFixed(0)} ° C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Icon(
                    Icons.cloudy_snowing,
                    color: Colors.white,
                    size: 90.0,
                  ),
                  Column(
                      children: weather
                          .map((cuaca) => Column(
                                children: <Widget>[
                                  Text(
                                    cuaca.main,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ))
                          .toList())
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Column(
                children: weather
                    .map((cuaca) => Column(
                          children: <Widget>[
                            Text(
                              cuaca.description,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ))
                    .toList()),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black.withOpacity(0.6),
            ),
            margin: EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.air_rounded,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        Container(
                          child: Text(
                            "Wind Speed",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${wind.speed}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    width: 1,
                    color: Colors.white,
                    height: 100,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.water,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        Container(
                          child: Text(
                            "Humidity",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${suhu.humidity}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    width: 1,
                    color: Colors.white,
                    height: 100,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.wb_cloudy_sharp,
                          color: Colors.white,
                          size: 70.0,
                        ),
                        Container(
                          child: Text(
                            "Pressure",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${suhu.pressure}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: Forecast(
                        kota: name,
                        lat: coord.lat.toString(),
                        long: coord.lon.toString(),
                        suhu: suhuC_,
                        suhufeel: (suhu.feelsLike - 273).toStringAsFixed(0),
                        pressure: suhu.pressure.toString(),
                        hum: suhu.humidity.toString(),
                      )));
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(15),
              color: Colors.orange[600],
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  "Forecast Weather Data",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:clambi/forecast/parsing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

class Forecast extends StatefulWidget {
  final String kota;
  final String long;
  final String lat;
  final String suhu;
  final String suhufeel;
  final String pressure;
  final String hum;

  const Forecast({
    Key? key,
    required this.kota,
    required this.long,
    required this.lat,
    required this.suhu,
    required this.suhufeel,
    required this.pressure,
    required this.hum,
  }) : super(key: key);

  @override
  _ForecastState createState() => _ForecastState();
}

class _ForecastState extends State<Forecast> {
  String? kota, long, lat, suhu, suhufeel;

  //API Cuaca
  late Future<Welcome> _futureWelcome;
  String link =
      'https://api.openweathermap.org/data/2.5/forecast?lat=-7.6453&lon=112.9075&appid=f9926d1b6845d0737f68f9e46abb4894';

  Future<Welcome> fetchWelcome() async {
    final response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      return Welcome.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data Cuaca');
    }
  }

  //End Api Cuaca
  @override
  void initState() {
    super.initState();
    kota = widget.kota;
    long = widget.lat;
    lat = widget.long;
    suhu = widget.suhu;
    suhufeel = widget.suhufeel;
    _futureWelcome = fetchWelcome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[400],
        body: Container(
          color: Colors.blue[400],
          child: SingleChildScrollView(
            child: SafeArea(
                child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12, top: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                        Text(
                          "Weather Forecast",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _futureWelcome = fetchWelcome();
                            });
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ]),
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.cloud,
                            color: Colors.orange[300],
                            size: 60.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                              margin: EdgeInsets.all(5),
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "$kota",
                                    style: TextStyle(
                                        color: Colors.black45,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.black45,
                                        size: 15.0,
                                      ),
                                      Text(
                                        '  $lat ',
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "  -  $long'",
                                        style: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          "${suhu}°C",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        child: Text(
                          "Feels Like : ${suhufeel}°C",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ])),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<Welcome>(
                    future: _futureWelcome,
                    builder: (context, snapshot) {
                      var state = snapshot.connectionState;
                      if (state != ConnectionState.done) {
                        return Center(
                            child: Column(
                          children: <Widget>[
                            SizedBox(height: 100),
                            CircularProgressIndicator(
                              color: Colors.white,
                            )
                          ],
                        ));
                      } else {
                        if (snapshot.hasData) {
                          return MyForecast(listcuaca: snapshot.data!.list);
                        } else if (snapshot.hasError) {
                          return Center(child: Text("${snapshot.error}"));
                        } else {
                          return Text('');
                        }
                      }
                    }),
              ],
            )),
          ),
        ));
  }
}

class MyForecast extends StatelessWidget {
  final List<ListElement> listcuaca;
  const MyForecast({
    Key? key,
    required this.listcuaca,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[400],
      alignment: Alignment.topLeft,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: listcuaca
              .map((cuaca) => Column(
                    children: <Widget>[
                      SizedBox(
                        height: 6,
                      ),
                      Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    '${cuaca.dtTxt.day} / ${cuaca.dtTxt.month}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    '${cuaca.dtTxt.hour} : ${cuaca.dtTxt.minute}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    (cuaca.main.temp - 273).toStringAsFixed(0) +
                                        '°C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.cloud,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                margin: EdgeInsets.all(5),
                                child: Column(
                                    children: cuaca.weather
                                        .map((status) => Column(
                                              children: <Widget>[
                                                Text(
                                                  status.main.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ))
                                        .toList()),
                              ))
                            ],
                          ),
                        )
                      ])
                    ],
                  ))
              .toList()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MyError extends StatefulWidget {
  @override
  _MyErrorState createState() => _MyErrorState();
}

class _MyErrorState extends State<MyError> {
  String fire = "-";

  void read() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    DatabaseEvent event = await ref.once();
    print(event.snapshot.value);
    setState(() {
      fire = event.snapshot.value.toString();
    });
  }

  void resetdata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "jamend": " - ",
      "jamstart": " - ",
      "suhu": 0,
      "hum": 0,
      "keluarkan": 0,
      "masukan": 0,
      "status": "Cerah",
      "statusjemuran": 0,
      "tglend": " - ",
      "tglstart": " - ",
    });
  }

  void setdata() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "jamend": "17 : 0 : 00",
      "jamstart": "9 : 0 : 00",
      "suhu": 30,
      "hum": 70,
      "keluarkan": 0,
      "masukan": 0,
      "status": "Cerah",
      "statusjemuran": 0,
      "tglend": "2022-03-31",
      "tglstart": "2022-03-31",
    });
  }

  @override
  void initState() {
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Center(
                  child: Text("Data View"),
                ),
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 24,
                      color: Colors.green,
                    ),
                    onPressed: () {}),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("Firebase Data"),
            ),
            Container(
              color: Colors.orange,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "$fire",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            ElevatedButton(
              onPressed: () {
                resetdata();
                final snackBar = SnackBar(
                  backgroundColor: Color.fromARGB(255, 0, 20, 27),
                  content: const Text('Reset data berhasil'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text("Reset All Firebase Data"),
            ),
            ElevatedButton(
              onPressed: () {
                setdata();
                final snackBar = SnackBar(
                  backgroundColor: Color.fromARGB(255, 0, 20, 27),
                  content: const Text('dummy data berhasil ditambahkan'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text("Set Dummy data Firebase"),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("Weather Api (http get)"),
            ),
            Container(
              color: Colors.red,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "http://api.openweathermap.org/data/2.5/weather?q=pasuruan&appid=3c95727e876f0dbb3def499ea46fb708",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("Forecast Weather Api (http get)"),
            ),
            Container(
              color: Colors.blue,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "https://api.openweathermap.org/data/2.5/onecall?lat=-7.6453&lon=112.9075&exclude=hourly&appid=f9926d1b6845d0737f68f9e46abb4894",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("API KEY (open weather map)"),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.purple,
              margin: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "f9926d1b6845d0737f68f9e46abb4894",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("Flutter Version"),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.pink,
              margin: EdgeInsets.all(10),
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Flutter 2.13.00pre 1.66",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("APK Version"),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              margin: EdgeInsets.all(10),
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "name: clambi, description: A new Flutter project. , publish_to: no ,version: 1.0.0+1 environment: sdk: >=2.17.0-222.0.dev <3.0.0",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Text("Last Update"),
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.blue,
              margin: EdgeInsets.all(10),
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "31/03/2022",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}

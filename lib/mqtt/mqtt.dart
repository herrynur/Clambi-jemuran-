import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Mymqtt extends StatefulWidget {
  @override
  _MymqttState createState() => _MymqttState();
}

class _MymqttState extends State<Mymqtt> {
  bool masukan = false;
  String btn = "Masukan Jemuran";

  //Firebase
  String suhu = "0";
  String hum = "0";
  var hujan = 0;
  String cuaca = "-";
  String statusjemuran = "-";
  //Parameter cuaca
  //Sangat Cerah, Cerah, Mendung, Gerimis, Hujan

  //Suhu
  void Readsuhu_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/suhu');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        suhu = event.snapshot.value.toString();
      });
      print(suhu);
    });
  }

  //Hum
  void Readhum_() {
    DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data1/hum');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        hum = event.snapshot.value.toString();
      });
      print(hum);
    });
  }

  //Cuaca
  void Readcuaca_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/status');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        cuaca = event.snapshot.value.toString();
      });
      print(cuaca);
    });
  }

  //jemuran
  void Readjemuran_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/statusjemuran');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        statusjemuran = event.snapshot.value.toString();
      });
      print(statusjemuran);
    });
  }

  //Masukan
  void masukanjem() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "masukan": 1,
      "statusjemuran": 0,
    });
  }

  //Keluarkan
  void keluarkanjem() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "keluarkan": 1,
      "statusjemuran": 1,
    });
  }
  //end Firebase

  @override
  void initState() {
    super.initState();
    Readsuhu_();
    Readhum_();
    Readcuaca_();
    Readjemuran_();
    masukan = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 0, 20, 27),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  "Monitoring Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                ),
                margin:
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 15, bottom: 5),
                              child: Text(
                                "Temp : ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 15),
                              child: Text(
                                "$suhu °C",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 15, bottom: 5),
                              child: Text(
                                "Humidity : ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 15),
                              child: Text(
                                "$hum %",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      height: 1,
                      color: Colors.white,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Status Cuaca",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (cuaca == "Sangat Cerah" || cuaca == "Cerah")
                      Container(
                        child: Icon(
                          Icons.sunny,
                          color: Colors.white,
                          size: 90.0,
                        ),
                      ),
                    if (cuaca == "Mendung")
                      Container(
                        child: Icon(
                          Icons.cloud,
                          color: Colors.white,
                          size: 90.0,
                        ),
                      ),
                    if (cuaca == "Gerimis" || cuaca == "Hujan")
                      Container(
                        child: Icon(
                          Icons.cloudy_snowing,
                          color: Colors.white,
                          size: 90.0,
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "$cuaca",
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Control Jemuran",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.2),
                ),
                margin:
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        "Status Posisi Jemuran",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (statusjemuran == "1")
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Berada Di Luar",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (statusjemuran == "0")
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          "Berada Di Dalam",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (statusjemuran == "1")
                      GestureDetector(
                        onTap: () {
                          masukanjem();
                          final snackBar = SnackBar(
                            backgroundColor: Color.fromARGB(255, 0, 20, 27),
                            content: const Text('Jemuran Dimasukan'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(15),
                          color: Colors.orange,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Masukan Jemuran",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (statusjemuran == "0")
                      GestureDetector(
                        onTap: () {
                          keluarkanjem();
                          final snackBar = SnackBar(
                            backgroundColor: Color.fromARGB(255, 0, 20, 27),
                            content: const Text('Jemuran Dikeluarkan'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(15),
                          color: Colors.orange,
                          child: Container(
                            margin: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Keluarkan Jemuran",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

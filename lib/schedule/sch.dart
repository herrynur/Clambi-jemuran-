import 'package:clambi/error/error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class MySch extends StatefulWidget {
  @override
  _MySchState createState() => _MySchState();
}

class _MySchState extends State<MySch> {
  //update tgl
  void tglstart(String tgl) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "tglstart": tgl,
    });
  }

  void jamstart(String jam) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "jamstart": jam,
    });
  }

  void tglend(String tgl) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "tglend": tgl,
    });
  }

  void jamend(String jam) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "jamend": jam,
    });
  }
  //end

  //jadwal
  void sch(String status) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("data1");
    await ref.update({
      "schedul": status,
    });
  }
  //endjadwal

  //firebase select
  String _jamstart = "-";
  String _jamend = "-";
  String _tglstart = "-";
  String _tglend = "-";
  String _sch = "-";
  void jamstart_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/jamstart');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _jamstart = event.snapshot.value.toString();
      });
    });
  }

  void jamend_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/jamend');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _jamend = event.snapshot.value.toString();
      });
    });
  }

  void tglstart_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/tglstart');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _tglstart = event.snapshot.value.toString();
      });
    });
  }

  void tglend_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/tglend');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _tglend = event.snapshot.value.toString();
      });
    });
  }

  void sch_() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('data1/schedul');
    starCountRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        _sch = event.snapshot.value.toString();
        print(_sch);
      });
    });
  }

  //end select
  //date1
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String? formattedDate;
  DateTime selectedDate = DateTime.now();
  var hari;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        formattedDate = formatter.format(selectedDate);
        print(formattedDate);
        tglstart(formattedDate.toString());
      });
  }

  String? _hour, _minute, _time;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  var time_;
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute! + " : " + "00";
        time_ = _time;
        print("$time_");
        jamstart(time_.toString());
      });
  }

  //end date2
  //date2
  //date1
  var now1 = new DateTime.now();
  var formatter1 = new DateFormat('yyyy-MM-dd');
  String? formattedDate1;
  DateTime selectedDate1 = DateTime.now();
  var hari1;
  bool? _lights;

  Future<Null> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate1,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate1 = picked;
        formattedDate1 = formatter.format(selectedDate1);
        print(formattedDate1);
        tglend(formattedDate1.toString());
      });
  }

  String? _hour1, _minute1, _time1;
  TimeOfDay selectedTime1 = TimeOfDay(hour: 00, minute: 00);
  var time_1;
  Future<Null> _selectTime1(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime1,
    );
    if (picked != null)
      setState(() {
        selectedTime1 = picked;
        _hour1 = selectedTime1.hour.toString();
        _minute1 = selectedTime1.minute.toString();
        _time1 = _hour1! + ' : ' + _minute1! + " : " + "00";
        time_1 = _time1;
        print("$time_1");
        jamend(time_1.toString());
      });
  }

  @override
  void initState() {
    _lights = false;
    super.initState();
    tglend_();
    jamend_();
    jamstart_();
    tglstart_();
    sch_();
    print(_lights);
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
                  "Scheduler Control",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SwitchListTile(
                inactiveTrackColor: Colors.grey,
                title: const Text(
                  "Aktifkan Penjadwalan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                value: _lights!,
                onChanged: (bool value) {
                  setState(() {
                    _lights = value;
                    if (_lights == false) {
                      sch("0");
                      final snackBar = SnackBar(
                        backgroundColor: Color.fromARGB(255, 0, 20, 27),
                        content: const Text('Penjadwalan dimatikan'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    if (_lights == true) {
                      sch("1");
                      final snackBar = SnackBar(
                        backgroundColor: Color.fromARGB(255, 0, 20, 27),
                        content: const Text('Penjadwalan Diaktifkan'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  });
                },
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
                        "Jadwalkan Control Jemuran",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text("Pilih tanggal mulai  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("$_tglstart",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.calendar_month,
                                      size: 24,
                                      color: Colors.green[400],
                                    ),
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                  ),
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text("Pilih Jam mulai       ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("$_jamstart",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.schedule,
                                      size: 24,
                                      color: Colors.blue[400],
                                    ),
                                    onPressed: () {
                                      _selectTime(context);
                                    },
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text("Pilih tanggal berakhir  ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("$_tglend",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.calendar_month,
                                      size: 24,
                                      color: Colors.green[400],
                                    ),
                                    onPressed: () {
                                      _selectDate1(context);
                                    },
                                  ),
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text("Pilih Jam berakhir       ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("$_jamend",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.schedule,
                                      size: 24,
                                      color: Colors.blue[400],
                                    ),
                                    onPressed: () {
                                      _selectTime1(context);
                                    },
                                  ),
                                )
                              ]),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      onLongPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyError()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(15),
                        color: Colors.orange,
                        child: Container(
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          child: Text(
                            "Set Jadwal",
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

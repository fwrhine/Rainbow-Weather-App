import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:strings/strings.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'dart:convert';
import 'weatherConditions.dart';

String apiKey = "142286faa5bd8ccf1ae8df60bef70179";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  var temp;
  var conditionMain;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var city;

  var longitude;
  var latitude;

  var conditionCode;
  var conditionColor;

  var unit = 0; // 0 metric, 1 imperial
  var degree = "C"; // C metric, F imperial

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    setState(() {
      this.longitude = position.longitude;
      this.latitude = position.latitude;
    });
  }

  Future getWeather() async {
    String unit = this.unit == 0 ? "metric" : "imperial";
    String url = "http://api.openweathermap.org/data/2.5/weather?lat=" +
        this.latitude.toString() +
        "&lon=" +
        this.longitude.toString() +
        "&appid=" +
        apiKey +
        "&units=" +
        unit;

    http.Response response = await http.get(url);
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results['main']['temp'];
      this.conditionMain = results['weather'][0]['main'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.city = results['name'];
      this.conditionCode = setConditionCode(this.conditionMain);
      this.conditionColor = setConditionColor(this.conditionMain);
      this.degree = this.unit == 0 ? "C" : "F";
    });
  }

  void _getWeather() {
    Future.wait([getLocation()]).then((FutureOr) => {getWeather()});
  }

  @override
  void initState() {
    super.initState();
    this._getWeather();
  }

  Future<void> _onRefresh() async {
    setState(() {
      this._getWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height / 3 * 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: conditionColor != null
                                  ? conditionColor
                                  : [Color(0xFFFFFFFF), Color(0xFFFFFFFF)])),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.only(right: 25.0, top: 50.0),
                                    child: ToggleSwitch(
                                      initialLabelIndex: this.unit,
                                      minWidth: 75.0,
                                      activeBgColor: Color(0xFFfa6482),
                                      inactiveFgColor: Colors.white,
                                      labels: ['Metric', 'Imperial'],
                                      onToggle: (index) {
                                        setState(() {
                                          this.unit = index;
                                          _onRefresh();
                                        });
                                      },
                                    ))
                              ],
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 7.0),
                                  // child: Icon(Icons.cloud,
                                  //     color: Colors.white, size: 50.0),
                                  // child: Image.asset('assets/weather_icons/cloud.png')
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: FlareActor(
                                      "assets/weather_conditions.flr",
                                      animation: conditionCode,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                      city != null ? city.toString() : "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 60.0),
                                  child: Text(
                                      temp != null
                                          ? (temp.toInt().round()).toString() +
                                              "\u00B0" +
                                              degree
                                          : "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 50.0,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            )),
                          ])),
                  Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0),
                          child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView(
                                children: <Widget>[
                                  ListTile(
                                    dense: true,
                                    leading: Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: FaIcon(
                                          FontAwesomeIcons.thermometerHalf),
                                    ),
                                    title: Text("Temperature",
                                        style: TextStyle(fontSize: 16.0)),
                                    trailing: Text(
                                        temp != null
                                            ? (temp.toInt().round())
                                                    .toString() +
                                                "\u00B0" +
                                                degree
                                            : "",
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                  ListTile(
                                    leading: Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: FaIcon(FontAwesomeIcons.cloud),
                                    ),
                                    title: Text("Weather",
                                        style: TextStyle(fontSize: 16.0)),
                                    trailing: Text(
                                        description != null
                                            ? description
                                                .toString()
                                                .capitalizeFirstofEach
                                            : "",
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                  ListTile(
                                    leading: Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: FaIcon(FontAwesomeIcons.sun),
                                    ),
                                    title: Text("Humidity",
                                        style: TextStyle(fontSize: 16.0)),
                                    trailing: Text(
                                        humidity != null
                                            ? humidity.toString()
                                            : "",
                                        style: TextStyle(fontSize: 16.0)),
                                  ),
                                  ListTile(
                                    leading: Container(
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: FaIcon(FontAwesomeIcons.wind),
                                    ),
                                    title: Text("Wind Speed",
                                        style: TextStyle(fontSize: 16.0)),
                                    trailing: Text(
                                        windSpeed != null
                                            ? windSpeed.toString()
                                            : "",
                                        style: TextStyle(fontSize: 16.0)),
                                  )
                                ],
                              ))))
                ]))));
  }
}

extension CapExtension on String {
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => capitalize(str)).join(" ");
}

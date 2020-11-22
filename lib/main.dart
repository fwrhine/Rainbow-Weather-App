import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:strings/strings.dart';
import 'dart:convert';

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
  var description;
  var currently;
  var humidity;
  var windSpeed;

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=Brisbane&units=metric&appid=" +
            apiKey);
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.transparent
          //color set to transperent or set your own color
        )
    );

    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          height: MediaQuery.of(context).size.height / 3 * 2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [Color(0xFFFD5F7E), Color(0xFFB08BD7)])),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0, top: 100.0),
                  child: Icon(Icons.cloud, color: Colors.white, size: 50.0),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text("Brisbane",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w400)),
                ),
                Text(
                    temp != null
                        ? (temp.toInt().round()).toString() + "\u00B0C"
                        : "",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontWeight: FontWeight.w400)),
              ])),
      Container(
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
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
                          child: FaIcon(FontAwesomeIcons.thermometerHalf),
                        ),
                        title:
                        Text("Temperature", style: TextStyle(fontSize: 16.0)),
                        trailing: Text(
                            temp != null
                                ? (temp.toInt().round()).toString() + "\u00B0C"
                                : "",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                      ListTile(
                        leading: Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.cloud),
                        ),
                        title: Text("Weather", style: TextStyle(fontSize: 16.0)),
                        trailing: Text(
                            description != null
                                ? description.toString().capitalizeFirstofEach
                                : "",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                      ListTile(
                        leading: Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.sun),
                        ),
                        title: Text("Humidity", style: TextStyle(fontSize: 16.0)),
                        trailing: Text(humidity != null ? humidity.toString() : "",
                            style: TextStyle(fontSize: 16.0)),
                      ),
                      ListTile(
                        leading: Container(
                          width: 30,
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.wind),
                        ),
                        title: Text("Wind Speed", style: TextStyle(fontSize: 16.0)),
                        trailing: Text(
                            windSpeed != null ? windSpeed.toString() : "",
                            style: TextStyle(fontSize: 16.0)),
                      )
                    ],
                  ))))
    ]));
  }
}

extension CapExtension on String {
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => capitalize(str)).join(" ");
}

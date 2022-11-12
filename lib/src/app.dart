import 'package:flutter/material.dart';
import 'package:http/http.dart' show get;
import 'dart:convert';
import 'models/weather_model.dart';

class App extends StatefulWidget {
  createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  var mycontroller = TextEditingController();
  WeatherModel? weatherModel;

  Widget build(context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Current Weather Data'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${weatherModel?.weather?[0].description ?? 'Error fetching data/invalid city'}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${weatherModel?.main?.temp ?? 'Error fetching data/invalid city'}',
                style: TextStyle(fontSize: 40),
              ),
              textfield(),
              button(),
              const Padding(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  width: 150,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textfield() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:15.0),
      child: TextField(
        controller: mycontroller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter City Name',
        ),
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
        onPressed: () async {
          print(mycontroller.text);
          weatherModel = await getWeather(mycontroller.text);
          setState(() {});
        },
        child: Text('Get Weather info'));
  }

  getWeather(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=eb6d75a05b00484ed9aba7e98becc56a&units=metric';

    try {
      var res = await get(Uri.parse(url));
      print(res.body);
      if (res.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(res.body));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

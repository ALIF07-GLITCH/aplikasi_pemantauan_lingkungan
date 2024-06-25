import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final String place;

  const Result({Key? key, required this.place}) : super(key: key);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  late Future<Map<String, dynamic>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getDataFromAPI();
  }

  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=${widget.place}&APPID=8de92df2eb966feb71ed3a2a9dd5fb30&units=metric"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hasil Pemantauan",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: _futureData,
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                final data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lokasi: ${data['name']}, ${data['sys']['country']}",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${data['main']['temp']}°C",
                          style: TextStyle(fontSize: 48),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Feels Like: ${data['main']['feels_like']}°C",
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              "Humidity: ${data['main']['humidity']}%",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${data['weather'][0]['main']}",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${data['weather'][0]['description']}",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Wind Speed: ${data['wind']['speed']} m/s",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.network(
                        'https://flagcdn.com/w320/${data["sys"]["country"].toLowerCase()}.png',
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error_outline, size: 64, color: Colors.red);
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return const Text("Data tidak tersedia");
              }
            },
          ),
        ),
      ),
    );
  }
}

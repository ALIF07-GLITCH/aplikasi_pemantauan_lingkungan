import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BanjirResult extends StatefulWidget {
  final String place;

  const BanjirResult({Key? key, required this.place}) : super(key: key);

  @override
  State<BanjirResult> createState() => _BanjirResultState();
}

class _BanjirResultState extends State<BanjirResult> {
  Future<Map<String, dynamic>> getDataFromAPI() async {
    final response = await http.get(Uri.parse(
        "https://api.petaBencana.id/v2/flood?location=${widget.place}"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data); // Debugging statement to check response data
      return data;
    } else if (response.statusCode == 404) {
      throw Exception('Lokasi tidak ditemukan');
    } else {
      throw Exception('Gagal mengambil data dari API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Hasil Identifikasi Banjir",
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
        body: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
            future: getDataFromAPI(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.hasData) {
                final data = snapshot.data!; // non nullable

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lokasi: ${data["location"]["name"]}",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Status Banjir: ${data['flood']['status']}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Ketinggian Air: ${data["flood"]["water_level"]} cm',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    Image.network(
                      'https://www.petaBencana.id/images/flood.jpg',
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ],
                );
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
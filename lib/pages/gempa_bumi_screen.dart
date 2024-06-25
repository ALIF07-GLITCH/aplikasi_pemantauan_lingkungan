import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Gempa {
  final String tanggal;
  final String jam;
  final String lintang;
  final String bujur;
  final String magnitude;
  final String kedalaman;
  final String wilayah;

  Gempa({
    required this.tanggal,
    required this.jam,
    required this.lintang,
    required this.bujur,
    required this.magnitude,
    required this.kedalaman,
    required this.wilayah,
  });

  factory Gempa.fromJson(Map<String, dynamic> json) {
    return Gempa(
      tanggal: json['Tanggal'] as String,
      jam: json['Jam'] as String,
      lintang: json['Lintang'] as String,
      bujur: json['Bujur'] as String,
      magnitude: json['Magnitude'] as String,
      kedalaman: json['Kedalaman'] as String,
      wilayah: json['Wilayah'] as String,
    );
  }
}

class GempaBumiScreen extends StatefulWidget {
  @override
  _GempaBumiScreenState createState() => _GempaBumiScreenState();
}

class _GempaBumiScreenState extends State<GempaBumiScreen> {
  late Future<List<Gempa>> futureGempa;

  @override
  void initState() {
    super.initState();
    futureGempa = fetchGempa();
  }

  Future<List<Gempa>> fetchGempa() async {
    final response =
        await http.get(Uri.parse('https://data.bmkg.go.id/DataMKG/TEWS/autogempa.json'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse['Infogempa'] != null) {
        dynamic gempaData = jsonResponse['Infogempa']['gempa'];
        if (gempaData is List) {
          return gempaData.map<Gempa>((gempa) => Gempa.fromJson(gempa)).toList();
        } else if (gempaData is Map<String, dynamic>) {
          return [Gempa.fromJson(gempaData)];
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to parse JSON');
      }
    } else {
      throw Exception('Failed to load gempa');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAHAYA LINDU LO BRO'),
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
        child: FutureBuilder<List<Gempa>>(
          future: futureGempa,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (snapshot.hasData) {
              List<Gempa>? gempaList = snapshot.data;
              return ListView.builder(
                itemCount: gempaList!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${gempaList[index].tanggal} - ${gempaList[index].wilayah}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Magnitude: ${gempaList[index].magnitude}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Kedalaman: ${gempaList[index].kedalaman}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text("Data ne ora tersedia");
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'banjir_result.dart'; // Impor halaman hasil identifikasi banjir

class BanjirField extends StatefulWidget {
  const BanjirField({Key? key}) : super(key: key);

  @override
  _BanjirFieldState createState() => _BanjirFieldState();
}

class _BanjirFieldState extends State<BanjirField> {
  TextEditingController placeController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Identifikasi Banjir",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Masukkan lokasi",
                    border: OutlineInputBorder(),
                  ),
                  controller: placeController,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    String place = placeController.text;
                    if (place.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BanjirResult(place: place),
                        ),
                      );
                    } else {
                      setState(() {
                        errorMessage = 'Silakan masukkan lokasi yang valid';
                      });
                    }
                  },
                  child: const Text("Cek Kondisi"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 20.0),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

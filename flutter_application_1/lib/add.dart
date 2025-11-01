import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; 
import 'dart:math'; 
import 'wpis.dart'; 

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final _tytulController = TextEditingController();
  final _opisController = TextEditingController();
  String _wiadomoscLokalizacji = "Pobierz lokalizację";
  bool _ladowanieLokalizacji = false;

  Future<void> _pobierzAktualnaLokalizacje() async {
    setState(() { _ladowanieLokalizacji = true; _wiadomoscLokalizacji = "Pobieram..."; });
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) { throw Exception('GPS wyłączony.'); }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Odmówiono uprawnień');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Uprawnienia zablokowane');
      } 
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _wiadomoscLokalizacji = "Lat: ${position.latitude}, Lon: ${position.longitude}";
      });
    } catch (e) {
      setState(() { _wiadomoscLokalizacji = "Błąd: ${e.toString()}"; });
    } finally {
      setState(() { _ladowanieLokalizacji = false; });
    }
  }

  void _zapiszWpis() {
    if (_tytulController.text.isEmpty) { 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tytuł nie może być pusty!'))
      );
      return; 
    }

    String? zapisanaLokalizacja;
    if (_wiadomoscLokalizacji.startsWith("Lat:")) {
      zapisanaLokalizacja = _wiadomoscLokalizacji;
    }

    final nowyWpis = Wpis(
      id: Random().nextInt(900) + 101,
      title: _tytulController.text,
      body: _opisController.text,
      location: zapisanaLokalizacja, 
    );
    Navigator.pop(context, nowyWpis);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text('Dodaj wpis'), ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField( controller: _tytulController, decoration: InputDecoration(labelText: 'Tytuł'), ),
            SizedBox(height: 10),
            TextField( controller: _opisController, decoration: InputDecoration(labelText: 'Opis'), ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _ladowanieLokalizacji ? null : _pobierzAktualnaLokalizacje,
              child: Text('Pobierz lokalizację (GPS)'),
            ),
            SizedBox(height: 10),
            if (_ladowanieLokalizacji) CircularProgressIndicator() else Text(_wiadomoscLokalizacji),
            Spacer(), 
            ElevatedButton( onPressed: _zapiszWpis, child: Text('Zapisz'), )
          ],
        ),
      ),
    );
  }
}
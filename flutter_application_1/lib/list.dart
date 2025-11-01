import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'wpis.dart';
import 'detail.dart';
import 'add.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Wpis> wpisy = []; 
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _zaladujDane(); 
  }
  
  Future<void> _zaladujDane() async {
    try {
      final pobraneWpisy = await pobierzWpisy();
      setState(() {
        wpisy = pobraneWpisy;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<List<Wpis>> pobierzWpisy() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((wpis) => Wpis.fromJson(wpis)).take(8).toList();
    } else {
      throw Exception('Nie udało się załadować');
    }
  }

  void _nawigujDoDodajWpis(BuildContext context) async {
    final nowyWpis = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddScreen()),
    );

    if (nowyWpis != null && nowyWpis is Wpis) {
      setState(() {
        wpisy.insert(0, nowyWpis);
      });
    }
  }

  @override
  Widget build(BuildContextBcontext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mój Dziennik'),
      ),
      body: Center(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _nawigujDoDodajWpis(context);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return CircularProgressIndicator();
    }
    if (errorMessage != null) {
      return Text('Błąd: $errorMessage');
    }
    if (wpisy.isEmpty) {
      return Text('Brak wpisów.');
    }
    return ListView.builder(
      itemCount: wpisy.length,
      itemBuilder: (context, index) {
        final wpis = wpisy[index];
        return ListTile(
          leading: (wpis.location != null) ? Icon(Icons.location_pin) : Icon(Icons.notes),
          title: Text(wpis.title),
          subtitle: Text(
            wpis.location ?? wpis.body, 
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(wpis: wpis),
              ),
            );
          },
        );
      },
    );
  }
}
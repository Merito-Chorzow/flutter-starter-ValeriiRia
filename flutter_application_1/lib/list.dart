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
      return jsonResponse.map((wpis) => Wpis.fromJson(wpis)).toList();
    } else {
      throw Exception('Nie udało się załadować');
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
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
          title: Text(wpis.title),
          subtitle: Text(wpis.body, maxLines: 1),
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
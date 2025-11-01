import 'package:flutter/material.dart';
import 'wpis.dart'; 

class DetailScreen extends StatelessWidget {
  
  final Wpis wpis; 

  const DetailScreen({Key? key, required this.wpis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wpis.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${wpis.id}'),
            SizedBox(height: 10),

            if (wpis.location != null && wpis.location!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  'Lokalizacja: ${wpis.location!}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.blueAccent
                  ),
                ),
              ),

            Text(wpis.body), 
          ],
        ),
      ),
    );
  }
}
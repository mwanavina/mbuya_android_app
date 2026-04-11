import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  VoidCallback? get onPressed => null;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // lets have a button that redirects to loading page
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/loading');
              },
              icon: Icon(Icons.navigate_next),
              label: Text('Get Started'),
            )
          ],
        )
      ),
    );
  }
}
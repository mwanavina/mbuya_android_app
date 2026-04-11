import 'package:flutter/material.dart';

class Loading extends StatefulWidget{
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading'),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        elevation: 0,
      ),
      body: SafeArea(child: Text('this is loading screen')),
    );
  }
}
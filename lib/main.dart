import 'package:flutter/material.dart';

void main() {
  runApp(const NewSound());
}

class NewSound extends StatelessWidget {
  const NewSound({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewSound',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  
}

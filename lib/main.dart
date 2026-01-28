import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main(){
  //ProviderScope abilitates Riverpod everywhere
  runApp(
    const ProviderScope(
      child: FocusQuest(),
    ),
  );
}

class FocusQuest extends StatelessWidget{
  const FocusQuest({super.key})

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'FocusQuest',
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

//Schermata iniziale temporanea
class HomePage extends StatelessWidget{
  const HomePage({super.key})

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusQuest'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Inizia la tua avventura di studio!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_page.dart';

void main(){
  //ProviderScope abilitates Riverpod everywhere
  runApp(
    const ProviderScope(
      child: FocusQuest(),
    ),
  );
}

class FocusQuest extends StatelessWidget{
  const FocusQuest({super.key});

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

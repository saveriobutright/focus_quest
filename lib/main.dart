import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_page.dart';
import 'providers/theme_provider.dart';

void main(){
  //ProviderScope abilitates Riverpod everywhere
  runApp(
    const ProviderScope(
      child: FocusQuest(),
    ),
  );
}

class FocusQuest extends ConsumerWidget{
  const FocusQuest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'FocusQuest',
      debugShowCheckedModeBanner: false,  
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

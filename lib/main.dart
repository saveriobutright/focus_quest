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

//Home page (ConsumerWidget can read Riverpod data)
class HomePage extends ConsumerWidget{
  const HomePage({super.key})

  @override
  Widget build(BuildContext context, WidgetRef ref){

    //ref listens to the provider
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusQuest Dashboard'),
        centerTitle: true,
      ),

      //future provider can be: data ready, error, loading
      body: userAsync.when(
        //data ready
        data: (user) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Livello ${user.level}',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 10),

              //xp bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: user.currentXp / user.xpToNextLevel,
                  backgroundColor: Colors.grey[300],
                  color: Colors.deepPurple,
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 10),
              Text('${user.currentXp} / ${user.xpToNextLevel} XP'),
            ],
          ),
        ),
        //error
        error: (err, stack) => Center(child: Text('Errore: $err')),

        //loading
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
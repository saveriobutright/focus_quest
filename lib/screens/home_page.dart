import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../services/location_service.dart';

//Home page (ConsumerWidget can read Riverpod data)
class HomePage extends ConsumerWidget{
  const HomePage({super.key});


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


              const SizedBox(height: 30),


              ElevatedButton(
                onPressed: () async {
                  final isAtUni = await LocationService().isAtUniversity();


                  //security to avoid errors by closing the app during calculation
                  if (!context.mounted) return;


                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isAtUni 
                        ? "Sei in Università! XP guadagnati!"
                        : "Non sei in Università. Posizione attuale non valida."),
                      backgroundColor: isAtUni ? Colors.green : Colors.red,
                    ),
                  );
                },
                child: const Text("Test GPS: Verifica Posizione"),
              ),
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
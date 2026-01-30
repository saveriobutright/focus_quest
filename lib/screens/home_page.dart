import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../services/location_service.dart';
import '../services/sensor_service.dart';

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

                  if (isAtUni && context.mounted){
                    ref.read(userProvider.notifier).addXp(10);
                  }


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

              const SizedBox(height: 20),

              //Listen to sensors
              StreamBuilder<bool>(
                stream: SensorService().faceDownStream,
                builder:(context, snapshot) {
                  //if facedown activate bonus
                  final isRitualActive = snapshot.data ?? false;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRitualActive ? Colors.amber.withValues(alpha: 0.2) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isRitualActive ? Colors.amber : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                        Icon(
                          isRitualActive ? Icons.check_circle : Icons.do_not_disturb_on,
                          color: isRitualActive ? Colors.amber[800] : Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isRitualActive ? "Rituale di Studio Attivo" : "Gira il telefono per il Bonus",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isRitualActive ? Colors.amber[900] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
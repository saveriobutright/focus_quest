import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class HistoryPage extends ConsumerWidget{

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      body: userAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Riepilogo Studio",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            //progress card
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.stars, color: Colors.amber, size: 40),
                title: Text("Livello Attuale: ${user.level}"),
                subtitle: Text("Hai accumulato ${user.currentXp} XP in questa sessione"),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Suggerimenti per te",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),

            //achievements
            ListTile(
              leading: Icon(
                user.goalLevel5Reached ? Icons.check_circle : Icons.radio_button_unchecked,
                color: user.goalLevel5Reached ? Colors.green : Colors.grey,
              ),
              title: const Text("Raggiungi il livello 5"),
              subtitle: const Text("Premio: 100 XP"),
              //button appears only if level 5 is unredeemed
              trailing: (user.level >= 5 && !user.goalLevel5Reached)
                ? ElevatedButton(
                    onPressed: () => ref.read(userProvider.notifier).completeGoal('level5'),
                    child: const Text("Riscuoti"),
                  )
                : null,
            ),


            ListTile(
              leading: Icon(
                user.goalRitualUsed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: user.goalRitualUsed ? Colors.green : Colors.grey,
              ),
              title: const Text("Usa il Rituale di Studio"),
              subtitle: const Text("Premio: 50 XP"),
              trailing:  (user.goalRitualUsed == false)
                ? null
                : null,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }
}
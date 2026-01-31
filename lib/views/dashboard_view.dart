import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../services/location_service.dart';
import '../services/sensor_service.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ascoltiamo i dati dell'utente e lo stato della sessione
    final userAsync = ref.watch(userProvider);
    final isSessionActive = ref.watch(userProvider.notifier).isSessionActive;

    return userAsync.when(
      data: (user) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //Hero card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade700, Colors.purple.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    //Avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.amber, width: 3),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,
                        child: Icon(_getIconData(user.avatar), size: 35, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    //Lvl and name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "LIVELLO ${user.level}",
                              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            //animated xp bar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Progresso Quest", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("${user.currentXp} / ${user.xpToNextLevel} XP", style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    //fluid animation for xp bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: user.currentXp / user.xpToNextLevel),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 12,
                            backgroundColor: Colors.grey.shade200,
                            color: Colors.orangeAccent,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            //Actions and Sensors
            //Rituals
            StreamBuilder<bool>(
              stream: SensorService().faceDownStream,
              builder: (context, snapshot) {
                final isRitualActive = snapshot.data ?? false;

                // Notifichiamo il provider
                Future.microtask(() =>
                  ref.read(userProvider.notifier).updateStatus(true, isRitualActive)
                );

                return Card(
                  elevation: 4,
                  color: isRitualActive ? Colors.amber.shade50 : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isRitualActive ? Colors.amber : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          isRitualActive ? Icons.auto_fix_high : Icons.auto_fix_off,
                          color: isRitualActive ? Colors.amber.shade800 : Colors.grey,
                          size: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rituale di Concentrazione",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isRitualActive ? Colors.amber.shade900 : null,
                                ),
                              ),
                              Text(
                                isRitualActive 
                                  ? "Bonus XP Attivo: +150% focus!" 
                                  : "Gira il telefono per attivare il bonus",
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            //Start Quest Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (isSessionActive) {
                    ref.read(userProvider.notifier).stopAutoXp();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Quest completata! XP salvati.")),
                    );
                  } else {
                    final atUni = await LocationService().isAtUniversity();
                    if (atUni && context.mounted) {
                      // Recuperiamo lo stato dei sensori per iniziare
                      ref.read(userProvider.notifier).startAutoXp(atUni, true); 
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Quest iniziata! Buona fortuna, Eroe.")),
                      );
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Devi essere in Università per iniziare la Quest!"),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                },
                icon: Icon(isSessionActive ? Icons.shield : Icons.fort),
                label: Text(
                  isSessionActive ? "TERMINA MISSIONE" : "INIZIA MISSIONE",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSessionActive ? Colors.redAccent : Colors.deepPurple.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 10,
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            //Test gps button
            TextButton.icon(
              onPressed: () async {
                final isAtUni = await LocationService().isAtUniversity();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isAtUni ? "Posizione valida" : "Posizione non valida")),
                  );
                }
              },
              icon: const Icon(Icons.location_on, size: 16),
              label: const Text("Verifica posizione GPS"),
            ),
          ],
        ),
      ),
      //loading
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.deepPurple),
            SizedBox(height: 20),
            Text("Caricamento dati dell'Eroe...", style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        )
      ),

      //error
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 20),
            Text('Si è verificato un errore magico: $err'),
            ElevatedButton(
              onPressed: () => ref.invalidate(userProvider),
              child: const Text("Riprova l'incantesimo"),
            ),
          ],
        ),
      ),
    );
  }

  //icons helper
  IconData _getIconData(String name) {
    switch (name) {
      case 'school': return Icons.school;
      case 'auto_stories': return Icons.auto_stories;
      case 'emoji_events': return Icons.emoji_events;
      default: return Icons.person;
    }
  }
}
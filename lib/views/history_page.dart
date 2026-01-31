import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class HistoryPage extends ConsumerWidget{

  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100], // Sfondo leggermente grigio per far risaltare le card
      body: userAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "Registro delle Imprese",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            
            _buildAchievementCard(
              title: "Raggiungi il livello 5",
              reward: "100 XP",
              isCompleted: user.goalLevel5Reached,
              canClaim: user.level >= 5 && !user.goalLevel5Reached,
              onClaim: () => ref.read(userProvider.notifier).completeGoal('level5'),
              icon: Icons.military_tech,
            ),
            
            _buildAchievementCard(
              title: "Il Primo Rituale",
              reward: "50 XP",
              isCompleted: user.goalRitualUsed,
              canClaim: false, // Per ora lasciamo la logica esistente
              onClaim: () {},
              icon: Icons.auto_fix_high,
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }

  Widget _buildAchievementCard({
    required String title,
    required String reward,
    required bool isCompleted,
    required bool canClaim,
    required VoidCallback onClaim,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: isCompleted ? Colors.green.shade100 : Colors.grey.shade200,
          child: Icon(icon, color: isCompleted ? Colors.green : Colors.grey),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Ricompensa: $reward", style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.w600)),
        trailing: canClaim 
          ? ElevatedButton(
              onPressed: onClaim,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              child: const Text("RISCUOTI"),
            )
          : (isCompleted ? const Icon(Icons.check_circle, color: Colors.green) : null),
      ),
    );
  }
}
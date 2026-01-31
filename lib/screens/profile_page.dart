import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends ConsumerWidget{
  
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      body: userAsync.when(
        data: (user) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              const SizedBox(height: 20),
              Text(
                user.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 40),

              SwitchListTile(
                title: const Text("Tema Scuro"),
                subtitle: const Text("Cambia l'aspetto dell'app"),
                secondary: const Icon(Icons.dark_mode),
                value: isDarkMode,
                onChanged: (value){
                  ref.read(themeProvider.notifier).state = value;
                },
              ),
            ],
          ),
        ), 
        error: (err, stack) => Center(child: Text('Errore: $err')), 
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
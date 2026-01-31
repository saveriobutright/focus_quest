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
  
    //Controller for name text
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Il Mio Profilo")),
      body: userAsync.when(
        data: (user) {
          nameController.text = user.name;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              //Lvl and avatar
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(_getIconData(user.avatar), size: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Livello ${user.level}", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Divider(height: 40),

              //Avatar change
              const Text("Scegli Avatar", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['person', 'school', 'auto_stories', 'emoji_events'].map((iconName) {
                  return GestureDetector(
                    onTap: () => ref.read(userProvider.notifier).updateAvatar(iconName),
                    child: CircleAvatar(
                      backgroundColor: user.avatar == iconName ? Colors.deepPurple : Colors.grey[200],
                      child: Icon(_getIconData(iconName), color: user.avatar == iconName ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              //Name edit 
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Nome Utente",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.edit),
                ),
                onSubmitted: (value) => ref.read(userProvider.notifier).updateName(value),
              ),

              const SizedBox(height: 20),

              //Theme switch
              SwitchListTile(
                title: const Text("Tema Scuro"),
                value: isDarkMode,
                onChanged: (val) => ref.read(themeProvider.notifier).state = val,
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }

  //Convert string to icondata
  IconData _getIconData(String name) {
    switch (name) {
      case 'school': return Icons.school;
      case 'auto_stories': return Icons.auto_stories;
      case 'emoji_events': return Icons.emoji_events;
      default: return Icons.person;
    }
  }
}
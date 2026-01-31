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
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilo Eroe"),
        centerTitle: true,
      ),
      body: userAsync.when(
        data: (user) {
          //initialize controller text only if not already writing
          nameController.text = user.name;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                //Profile header
                _animateSection(
                  index: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade700, Colors.purple.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                    ],
                  ),
                  child: Column(
                    children: [
                      TweenAnimationBuilder<double>(
                        key: ValueKey(user.avatar),
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.elasticOut,
                        builder: (context, value, child){
                          return Transform.scale(
                            scale: 0.8 + (value * 0.2),
                            child: child,
                          );
                        },
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white24,
                          child: Icon(_getIconData(user.avatar), size: 50, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        user.name,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Studente di Livello ${user.level}",
                        style: TextStyle(color: Colors.amber.shade300, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
                
              const SizedBox(height: 30),

              //Avatar
              _animateSection(
                index:1,
                child: Column(
                  children: [ 
                    const Text("Cambia la tua Icona", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['person', 'school', 'auto_stories', 'emoji_events'].map((iconName) {
                        final isSelected = user.avatar == iconName;
                        return GestureDetector(
                          onTap: () => ref.read(userProvider.notifier).updateAvatar(iconName),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.deepPurple.withOpacity(0.1) : Colors.transparent,
                              shape: BoxShape.circle,
                              border: Border.all(color: isSelected ? Colors.deepPurple : Colors.transparent, width: 2),
                            ),
                            child: Icon(
                              _getIconData(iconName), 
                              size: 30, 
                              color: isSelected ? Colors.deepPurple : Colors.grey
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //Name editing
              _animateSection(
                index: 2,
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nome dell'Eroe",
                    prefixIcon: const Icon(Icons.edit_note),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.05),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      ref.read(userProvider.notifier).updateName(value.trim());
                    }
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),

              //Theme settings
              _animateSection(
                index: 3,
                child: SwitchListTile(
                  title: const Text("Modalità Oscura"),
                  subtitle: const Text("Ideale per le sessioni di studio notturne"),
                  secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.amber),
                  value: isDarkMode,
                  onChanged: (val) {
                    //Update theme state
                    ref.read(themeProvider.notifier).state = val;
                  },
                ),
              ),
            ],
          ),
        );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }

  //Waterfall animation
  Widget _animateSection({required Widget child, required int index}){
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0), 
      duration: Duration(milliseconds: 400 + (index * 150)), 
      curve: Curves.easeOutQuart,
      builder: (context, value, child){
        return Opacity(
          opacity: value,
          child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
          ),
        );
      },
      child: child,
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
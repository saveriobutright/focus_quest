import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/database_helper.dart';

//Notifier that handles the logic
class UserNotifier extends AsyncNotifier<UserModel>{

  @override
  Future<UserModel> build() async {
    //getUser
    final userData = await DatabaseHelper.instance.getUserData();

    //default user
    if(userData != null){
      return UserModel.fromMap(userData);
    } else {
      return UserModel(name: "Studente", level: 1, currentXp: 0);
    }
  }

  //XP
  Future<void> addXp(int amount) async{
    //current user
    final currentUser = state.value;
    if(currentUser == null) return;

    //new values
    int newXp = currentUser.currentXp + amount;
    int newLevel = currentUser.level;
    int xpToNext = currentUser.xpToNextLevel;

    //lvl up logic
    if(newXp >= xpToNext){
      newXp -= xpToNext;
      newLevel++;
    }

    //updated object
    final updatedUser = currentUser.copyWith(
      currentXp: newXp,
      level: newLevel
    );

    //db update
    await DatabaseHelper.instance.updateUser(newLevel, newXp);

    //update interface
    state = AsyncData(updatedUser);
  }
}

//exposed provider
final userProvider = AsyncNotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
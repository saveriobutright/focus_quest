import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/database_helper.dart';
import 'dart:async';

//Notifier that handles the logic
class UserNotifier extends AsyncNotifier<UserModel>{

  Timer? _studyTimer;

  bool _currentAtUni = false;
  bool _currentFaceDown = false;
  bool _isSessionActive = false;
  bool get isSessionActive => _isSessionActive;

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

  void updateStatus(bool atUni, bool faceDown){
    _currentAtUni = atUni;
    _currentFaceDown = faceDown;
  }

  Future<void> updateName(String newName) async {
    final currentUser = state.value;
    if(currentUser == null) return;

    state = AsyncData(currentUser.copyWith(name: newName));

    final db = await DatabaseHelper.instance.database;
    await db.update('user', {'name': newName}, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> updateAvatar(String avatarName) async {
    final currentUser = state.value;
    if(currentUser == null) return;

    state = AsyncData(currentUser.copyWith(avatar: avatarName));

    final db = await DatabaseHelper.instance.database;
    await db.update('user', {'avatar': avatarName}, where: 'id = ?', whereArgs: [1]);
  }

  //XP every x seconds
  void startAutoXp(bool isAtUni, bool isFaceDown){
    //starting values
    _currentAtUni = isAtUni;
    _currentFaceDown = isFaceDown;
    
    //stop existing timers
    _studyTimer?.cancel();
    _isSessionActive = true;

    //every 10 secs check and prize
    _studyTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentAtUni) {
        int xpDati = _currentFaceDown ? 25 : 10;
        addXp(xpDati);
      }
    });

    //notify interface with state change
    state = AsyncData(state.value!);
  }

  void completeGoal(String goalType) async {
    final currentUser = state.value;
    if(currentUser == null) return;

    if(goalType == 'level5' && currentUser.level >= 5 && !currentUser.goalLevel5Reached){
      //update object
      state = AsyncData(currentUser.copyWith(goalLevel5Reached: true));

      //save achievement to db
      await DatabaseHelper.instance.updateGoalStatus('goalLevel5Reached', true);

      //xp prize
      addXp(100);
    }

    else if(goalType == 'ritual' && !currentUser.goalRitualUsed){
      state = AsyncData(currentUser.copyWith(goalRitualUsed: true));
      await DatabaseHelper.instance.updateGoalStatus('goalRitualUsed', true);
      await addXp(50);
    }
  }

  void stopAutoXp(){
    _studyTimer?.cancel();
    _isSessionActive = false;
    state = AsyncData(state.value!);
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
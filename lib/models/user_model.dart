class UserModel {
  final String name;
  final int level;
  final int currentXp;
  final bool goalLevel5Reached;
  final bool goalRitualUsed;
  final String avatar;

  UserModel({
    required this.name,
    required this.level,
    required this.currentXp,
    this.goalLevel5Reached = false,
    this.goalRitualUsed = false,
    this.avatar = 'person',
  });

  //Missing XP to get to the next level
  int get xpToNextLevel => level * 1000;

  // Transform database data to a Dart object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      level: map['level'],
      currentXp: map['current_xp'],
      goalLevel5Reached: map['goalLevel5Reached'] == 1,
      goalRitualUsed: map['goalRitualUser'] == 1,
      avatar: map['avatar'],
    );
  }

  //save to db
  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'level' : level,
      'current_xp' : currentXp,
      'goalLevel5Reached' : goalLevel5Reached ? 1 : 0,
      'goalRitualUsed' : goalRitualUsed ? 1 : 0,
      'avatar' : avatar,
    };
  }

  //copy changing only some attributes
  UserModel copyWith({
    String? name,
    int? level,
    int? currentXp,
    bool? goalLevel5Reached,
    bool? goalRitualUsed,
    String? avatar,
  }) {
    return UserModel(
      name: name ?? this.name, 
      level: level ?? this.level, 
      currentXp: currentXp ?? this.currentXp,
      goalLevel5Reached: goalLevel5Reached ?? this.goalLevel5Reached,
      goalRitualUsed: goalRitualUsed ?? this.goalRitualUsed,
      avatar: avatar ?? this.avatar,
    );
  }
}
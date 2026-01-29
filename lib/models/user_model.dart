class UserModel {
  final String name;
  final int level;
  final int currentXp;

  UserModel({
    required this.name,
    required this.level,
    required this.currentXp,
  });

  //Missing XP to get to the next level
  int get xpToNextLevel => level * 1000;

  // Transform database data to a Dart object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      level: map['level'],
      currentXp: map['current_xp'],
    );
  }

  //copy changing only some attributes
  UserModel copyWith({
    String? name,
    int? level,
    int? currentXp,
  }) {
    return UserModel(
      name: name ?? this.name, 
      level: level ?? this.level, 
      currentXp: currentXp ?? this.currentXp,
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model-dart';
import '../services/database_helper.dart';

//load user data in db
final userProvider = FutureProvider<UserModel>((ref) async{

    //retrieve map from db
    final userData = await DatabaseHelper.instance.getUserData();

    if(userData != null){
        //transform map into UserModel
        return UserModel.fromMap(userData);
    }else{
        //emergency: if null, return basic user
        return UserModel(name: "Studente", level: 1, currentXp: 0);
    }
});
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviebox/src/core/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  Future<UserCredential?> login(String email, String password) async {
    try {
     UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  Future<UserCredential?>  signup(String email, String password) async {
    try {
     UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  Future saveUser(String? name, String? email) async {
    MyUser? userData = await findUserData();
    if(userData!=null)
    {
    if(userData.email!=_auth.currentUser?.email && userData.uid!=_auth.currentUser?.uid){
    await fireStoreInstance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .set({'uid': _auth.currentUser?.uid, 'email': email, 'name': name});
    }
    } else {
      await fireStoreInstance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .set({'uid': _auth.currentUser?.uid, 'email': email, 'name': name});
    }
   }
   //SIGN OUT METHOD
  Future<void> signOut() async {
    await _auth.signOut();
  }
  Future<MyUser?> findUserData() async{   
    QuerySnapshot<Map<String, dynamic>> collection  =await fireStoreInstance.collection('users').where('email',isEqualTo: _auth.currentUser?.email).limit(1).get();
    if(collection.size>0){
    Map<String, dynamic> data  =collection.docs.first.data();
    MyUser userData = MyUser.fromMap(data);
    return userData;
    }
    return null;
  }
  Future updateUser(MyUser user){
    Map<String, dynamic> data  =user.toMap();
    return fireStoreInstance.collection('users').doc(user.uid).update(data).then((value) => {
      print('user updated')
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moviebox/core/model/user.model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final fireStoreInstance = FirebaseFirestore.instance;
  Future<MyUser?> findUserData() async {
    QuerySnapshot<Map<String, dynamic>> collection = await fireStoreInstance
        .collection('users')
        .where('email', isEqualTo: _auth.currentUser?.email)
        .limit(1)
        .get();
    if (collection.size > 0) {
      Map<String, dynamic> data = collection.docs.first.data();
      MyUser userData = MyUser.fromMap(data);
      return userData;
    }
    return null;
  }

  Future updateUser(MyUser user) {
    Map<String, dynamic> data = user.toMap();
    return fireStoreInstance
        .collection('users')
        .doc(user.uid)
        .update(data)
        .then((value) => {print('user updated')});
  }

  Future saveUser(String? name, String? email) async {
    MyUser? userData = await findUserData();
    if (userData != null) {
      if (userData.email != _auth.currentUser?.email &&
          userData.uid != _auth.currentUser?.uid) {
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
}
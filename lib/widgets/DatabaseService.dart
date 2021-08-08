import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference users = Firestore.instance.collection('users');
  final CollectionReference dishes = Firestore.instance.collection('dishes');

  Future updateUserData(String firstname, String lastname, String address) async {
    return await users.document(uid).setData({
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
    });
  }

  Future addFavorites(String dish) async {
    return await dishes.document(dish).updateData({
      'favorites': FieldValue.arrayUnion([uid]),
    });
  }
  
  Future removeFavorites(String dish) async {
    return await dishes.document(dish).updateData({
      'favorites': FieldValue.arrayRemove([uid]),
    });
  }

  Future addOrders(String dish, int quantity) async {
    return await dishes.document(dish).updateData({
      'orders': FieldValue.arrayUnion([uid]),
    });
  }

  Future removeOrders(String dish) async {
    return await dishes.document(dish).updateData({
      'orders': FieldValue.arrayRemove([uid]),
    });
  }

  Future addComment(String dish, String comment) async {
    return await dishes.document(dish).updateData({
      'comments': FieldValue.arrayUnion([comment]),
    });
  }

}
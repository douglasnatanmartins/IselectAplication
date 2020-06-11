import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;

  Map<String, dynamic> userData = Map();
  Map<String, dynamic> dataToUpdate = Map();

  bool isLoading = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);


  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void saveEndereco({@required Map<String, dynamic> dataToUpdate, @required String endereco, @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading= true;
    notifyListeners();

    await Firestore.instance.collection("users").document(firebaseUser.uid).
    updateData(dataToUpdate).then((adrress){

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((erro){
      print(erro);
      onFail();
      notifyListeners();
    });
  }
  void savedTelefone({@required Map<String, dynamic> dataToUpdatet, @required String endereco, @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading= true;
    notifyListeners();

    await Firestore.instance.collection("users").document(firebaseUser.uid).
    updateData(dataToUpdatet).then((adrress){

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((erro){
      print(erro);
      onFail();
      notifyListeners();
    });
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}){

    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async {
      firebaseUser = user.user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((erro){
      print(erro);
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }
  Future<Null> loadImage() async {
    var image = FirebaseStorage.instance.ref().getDownloadURL();
    return image;
  }


  void saveDataImage(File imagePicture) async {
    Map<String , dynamic> dataToUpdate = {};
    if(imagePicture != null ){
      final StorageReference storageReference = FirebaseStorage().ref().child("users").child(firebaseUser.uid);
      final StorageUploadTask uploadTask = storageReference.putFile(imagePicture);
      final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
        // You can use this to notify yourself or your user in any kind of way.
        // For example: you could use the uploadTask.events stream in a StreamBuilder instead
        // to show your user what the current status is. In that case, you would not need to cancel any
        // subscription as StreamBuilder handles this automatically.

        // Here, every StorageTaskEvent concerning the upload is printed to the logs.
        print('EVENT ${event.type}');
      });
      StorageTaskSnapshot snap = await uploadTask.onComplete;
      dataToUpdate["icon"] = await snap.ref.getDownloadURL();
      Firestore.instance.collection("users").document(firebaseUser.uid).updateData(dataToUpdate);

      streamSubscription.cancel();
    }
  }

  void signIn({@ required String email, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}) async {

    isLoading = true;
    notifyListeners();

    _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((user)async{
      firebaseUser = user.user;

      await _loadCurrentUser();

      onSuccess();
      isLoading = false;
      notifyListeners();

    }).catchError((erro){
      print(erro);
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }

  void signOut() async {
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();

  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isloggedIn() {
    return firebaseUser != null;
  }

  bool isLoad() {
    return userData != null;

  }

  Future<Null> _saveUserData(Map<String, dynamic> userData, ) async {
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser()async{
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser =
        await Firestore.instance.collection("users").document(
            firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();

  }

  Future<Null> saveStar({@required Map<String, dynamic> saveDataStar, @required VoidCallback onSuccess}) async {

    var _rating = saveDataStar;
    isLoading = true;
    notifyListeners();

    if(firebaseUser != null){
      Firestore.instance.collection("categories").document(firebaseUser.uid).updateData(
          saveDataStar
      );
      onSuccess();
    }
    isLoading = false;
    notifyListeners();
  }

}

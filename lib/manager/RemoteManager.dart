import 'dart:async';
import 'package:account_managment/manager/PreferencesManager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:account_managment/model/Account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RemoteManager {

  static const String _ACCOUNTS_COLLECTION_NAME = 'ams';

  static RemoteManager _instance;

  final GoogleSignIn _googleSignIn = new GoogleSignIn();


  RemoteManager.createInstance();

  factory RemoteManager() {
    if(_instance == null)
      _instance = RemoteManager.createInstance();

    return _instance;
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return user.uid;
  }

  Future<void> resetPassword(String email) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  Future<FirebaseUser> signInByGoogleAccount() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    return user;
  }

  Future<bool> signInByFacebookAccount() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        throw new Exception(facebookLoginResult.errorMessage);
      case FacebookLoginStatus.cancelledByUser:
        throw new Exception("Cancelled by user !");
      case FacebookLoginStatus.loggedIn:
        return true;
    }
  }

  Future<void> pushAccountsToServer(accountsList) {
    var db = Firestore.instance;
    var batch = db.batch();
    var cr = db
        .collection(_ACCOUNTS_COLLECTION_NAME)
        .document(PreferencesManager.createInstance().getUser())
        .collection("accounts");
    accountsList.forEach((acnt) => batch.setData(cr.document('${acnt.id}'), acnt.toMap()));
    batch.commit();
  }

  Future<List<Account>> fetchAccountsFromServer() {
    var c = new Completer<List<Account>>();
    Firestore db = Firestore.instance;
//    var snapshots = db.collection(_ACCOUNTS_COLLECTION_NAME).snapshots();
    var snapshots = db
        .collection(_ACCOUNTS_COLLECTION_NAME)
        .document(PreferencesManager.createInstance().getUser())
        .collection("accounts")
        .snapshots();
    var accounts = <Account>[];
    snapshots.listen((QuerySnapshot snapshot) {
        accounts = snapshot.documents.map((ds) => Account.fromMap(ds.data)).toList();

        if(! c.isCompleted)
          c.complete(accounts);
      }
    );

    return c.future;
  }

}

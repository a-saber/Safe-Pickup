import 'package:firebase_auth/firebase_auth.dart';

abstract class Failure {
  final String errorMessage;
  Failure(this.errorMessage);
}

class DataFailure extends Failure {
  DataFailure(super.errorMessage);
}

class FirebaseFailure extends Failure {
  FirebaseFailure(super.errorMessage);

  factory FirebaseFailure.fromFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return FirebaseFailure('The email address is not valid.');
      case 'user-disabled':
        return FirebaseFailure('The user corresponding to the given email has been disabled.');
      case 'user-not-found':
        return FirebaseFailure('There is no user corresponding to the given email.');
      case 'wrong-password':
        return FirebaseFailure('The password is invalid for the given email.');
      case 'email-already-in-use':
        return FirebaseFailure('The email address is already in use by another account.');
      case 'operation-not-allowed':
        return FirebaseFailure('Email/Password accounts are not enabled.');
      case 'weak-password':
        return FirebaseFailure('The password is not strong enough.');
      default:
        return FirebaseFailure('An undefined Error happened.');
    }
  }
}

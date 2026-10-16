import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/call_exception.dart';

String callErrorMessage(Object error) => switch (error) {
  CallException(:final message) => message,
  FirebaseException(code: 'permission-denied') =>
    'Calls are only available between you and your coach.',
  _ => 'Something went wrong with the call. Please try again.',
};

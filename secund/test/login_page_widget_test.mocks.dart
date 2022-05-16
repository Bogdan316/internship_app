// Mocks generated by Mockito 5.1.0 from annotations
// in internship_app_fis/test/login_page_widget_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter/src/widgets/navigator.dart' as _i6;
import 'package:internship_app_fis/models/user.dart' as _i5;
import 'package:internship_app_fis/services/user_service.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mysql1/mysql1.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeResults_0 extends _i1.Fake implements _i2.Results {}

/// A class which mocks [UserService].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserService extends _i1.Mock implements _i3.UserService {
  MockUserService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i5.User?> getUser(_i5.User? user) =>
      (super.noSuchMethod(Invocation.method(#getUser, [user]),
          returnValue: Future<_i5.User?>.value()) as _i4.Future<_i5.User?>);
  @override
  _i4.Future<bool> usernameExists(_i5.User? user) =>
      (super.noSuchMethod(Invocation.method(#usernameExists, [user]),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<void> addUser(_i5.User? user) =>
      (super.noSuchMethod(Invocation.method(#addUser, [user]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> deleteUser(_i5.User? user) =>
      (super.noSuchMethod(Invocation.method(#deleteUser, [user]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}

/// A class which mocks [MySqlConnection].
///
/// See the documentation for Mockito's code generation for more information.
class MockMySqlConnection extends _i1.Mock implements _i2.MySqlConnection {
  MockMySqlConnection() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<dynamic> close() =>
      (super.noSuchMethod(Invocation.method(#close, []),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<_i2.Results> query(String? sql, [List<Object?>? values]) =>
      (super.noSuchMethod(Invocation.method(#query, [sql, values]),
              returnValue: Future<_i2.Results>.value(_FakeResults_0()))
          as _i4.Future<_i2.Results>);
  @override
  _i4.Future<List<_i2.Results>> queryMulti(
          String? sql, Iterable<List<Object?>>? values) =>
      (super.noSuchMethod(Invocation.method(#queryMulti, [sql, values]),
              returnValue: Future<List<_i2.Results>>.value(<_i2.Results>[]))
          as _i4.Future<List<_i2.Results>>);
  @override
  _i4.Future<dynamic> transaction(Function? queryBlock) =>
      (super.noSuchMethod(Invocation.method(#transaction, [queryBlock]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
}

/// A class which mocks [NavigatorObserver].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigatorObserver extends _i1.Mock implements _i6.NavigatorObserver {
  @override
  void didPush(_i6.Route<dynamic>? route, _i6.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didPop(_i6.Route<dynamic>? route, _i6.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didRemove(
          _i6.Route<dynamic>? route, _i6.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didRemove, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didReplace(
          {_i6.Route<dynamic>? newRoute, _i6.Route<dynamic>? oldRoute}) =>
      super.noSuchMethod(
          Invocation.method(
              #didReplace, [], {#newRoute: newRoute, #oldRoute: oldRoute}),
          returnValueForMissingStub: null);
  @override
  void didStartUserGesture(
          _i6.Route<dynamic>? route, _i6.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
          Invocation.method(#didStartUserGesture, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didStopUserGesture() =>
      super.noSuchMethod(Invocation.method(#didStopUserGesture, []),
          returnValueForMissingStub: null);
}
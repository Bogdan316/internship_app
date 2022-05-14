// Mocks generated by Mockito 5.1.0 from annotations
// in internship_app_fis/test/ongoing_internships_page_widget_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:flutter/material.dart' as _i9;
import 'package:internship_app_fis/models/internship.dart' as _i7;
import 'package:internship_app_fis/models/user.dart' as _i5;
import 'package:internship_app_fis/services/auth_service.dart' as _i8;
import 'package:internship_app_fis/services/internship_service.dart' as _i6;
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

class _FakeIterator_0<E> extends _i1.Fake implements Iterator<E> {}

class _FakeResultRow_1 extends _i1.Fake implements _i2.ResultRow {}

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

/// A class which mocks [InternshipService].
///
/// See the documentation for Mockito's code generation for more information.
class MockInternshipService extends _i1.Mock implements _i6.InternshipService {
  MockInternshipService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> addInternship(_i7.Internship? internship) =>
      (super.noSuchMethod(Invocation.method(#addInternship, [internship]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<List<_i7.Internship>> getAllCompanyInternships(
          _i5.Company? company) =>
      (super.noSuchMethod(
              Invocation.method(#getAllCompanyInternships, [company]),
              returnValue:
                  Future<List<_i7.Internship>>.value(<_i7.Internship>[]))
          as _i4.Future<List<_i7.Internship>>);
  @override
  _i4.Future<void> deleteInternship(_i7.Internship? internship) =>
      (super.noSuchMethod(Invocation.method(#deleteInternship, [internship]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> updateInternship(_i7.Internship? internship) =>
      (super.noSuchMethod(Invocation.method(#updateInternship, [internship]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i8.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i5.User?> signupUser() =>
      (super.noSuchMethod(Invocation.method(#signupUser, []),
          returnValue: Future<_i5.User?>.value()) as _i4.Future<_i5.User?>);
  @override
  _i4.Future<_i5.User?> loginUser() =>
      (super.noSuchMethod(Invocation.method(#loginUser, []),
          returnValue: Future<_i5.User?>.value()) as _i4.Future<_i5.User?>);
}

/// A class which mocks [Results].
///
/// See the documentation for Mockito's code generation for more information.
class MockResults extends _i1.Mock implements _i2.Results {
  MockResults() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i2.Field> get fields => (super.noSuchMethod(Invocation.getter(#fields),
      returnValue: <_i2.Field>[]) as List<_i2.Field>);
  @override
  Iterator<_i2.ResultRow> get iterator =>
      (super.noSuchMethod(Invocation.getter(#iterator),
              returnValue: _FakeIterator_0<_i2.ResultRow>())
          as Iterator<_i2.ResultRow>);
  @override
  int get length =>
      (super.noSuchMethod(Invocation.getter(#length), returnValue: 0) as int);
  @override
  bool get isEmpty =>
      (super.noSuchMethod(Invocation.getter(#isEmpty), returnValue: false)
          as bool);
  @override
  bool get isNotEmpty =>
      (super.noSuchMethod(Invocation.getter(#isNotEmpty), returnValue: false)
          as bool);
  @override
  _i2.ResultRow get first => (super.noSuchMethod(Invocation.getter(#first),
      returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  _i2.ResultRow get last => (super.noSuchMethod(Invocation.getter(#last),
      returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  _i2.ResultRow get single => (super.noSuchMethod(Invocation.getter(#single),
      returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  Iterable<R> cast<R>() =>
      (super.noSuchMethod(Invocation.method(#cast, []), returnValue: <R>[])
          as Iterable<R>);
  @override
  Iterable<_i2.ResultRow> followedBy(Iterable<_i2.ResultRow>? other) =>
      (super.noSuchMethod(Invocation.method(#followedBy, [other]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  Iterable<T> map<T>(T Function(_i2.ResultRow)? toElement) =>
      (super.noSuchMethod(Invocation.method(#map, [toElement]),
          returnValue: <T>[]) as Iterable<T>);
  @override
  Iterable<_i2.ResultRow> where(bool Function(_i2.ResultRow)? test) =>
      (super.noSuchMethod(Invocation.method(#where, [test]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  Iterable<T> whereType<T>() =>
      (super.noSuchMethod(Invocation.method(#whereType, []), returnValue: <T>[])
          as Iterable<T>);
  @override
  Iterable<T> expand<T>(Iterable<T> Function(_i2.ResultRow)? toElements) =>
      (super.noSuchMethod(Invocation.method(#expand, [toElements]),
          returnValue: <T>[]) as Iterable<T>);
  @override
  bool contains(Object? element) =>
      (super.noSuchMethod(Invocation.method(#contains, [element]),
          returnValue: false) as bool);
  @override
  void forEach(void Function(_i2.ResultRow)? action) =>
      super.noSuchMethod(Invocation.method(#forEach, [action]),
          returnValueForMissingStub: null);
  @override
  _i2.ResultRow reduce(
          _i2.ResultRow Function(_i2.ResultRow, _i2.ResultRow)? combine) =>
      (super.noSuchMethod(Invocation.method(#reduce, [combine]),
          returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  T fold<T>(T? initialValue, T Function(T, _i2.ResultRow)? combine) =>
      throw UnsupportedError(
          '\'fold\' cannot be used without a mockito fallback generator.');
  @override
  bool every(bool Function(_i2.ResultRow)? test) =>
      (super.noSuchMethod(Invocation.method(#every, [test]), returnValue: false)
          as bool);
  @override
  String join([String? separator = r'']) => (super
          .noSuchMethod(Invocation.method(#join, [separator]), returnValue: '')
      as String);
  @override
  bool any(bool Function(_i2.ResultRow)? test) =>
      (super.noSuchMethod(Invocation.method(#any, [test]), returnValue: false)
          as bool);
  @override
  List<_i2.ResultRow> toList({bool? growable = true}) =>
      (super.noSuchMethod(Invocation.method(#toList, [], {#growable: growable}),
          returnValue: <_i2.ResultRow>[]) as List<_i2.ResultRow>);
  @override
  Set<_i2.ResultRow> toSet() =>
      (super.noSuchMethod(Invocation.method(#toSet, []),
          returnValue: <_i2.ResultRow>{}) as Set<_i2.ResultRow>);
  @override
  Iterable<_i2.ResultRow> take(int? count) =>
      (super.noSuchMethod(Invocation.method(#take, [count]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  Iterable<_i2.ResultRow> takeWhile(bool Function(_i2.ResultRow)? test) =>
      (super.noSuchMethod(Invocation.method(#takeWhile, [test]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  Iterable<_i2.ResultRow> skip(int? count) =>
      (super.noSuchMethod(Invocation.method(#skip, [count]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  Iterable<_i2.ResultRow> skipWhile(bool Function(_i2.ResultRow)? test) =>
      (super.noSuchMethod(Invocation.method(#skipWhile, [test]),
          returnValue: <_i2.ResultRow>[]) as Iterable<_i2.ResultRow>);
  @override
  _i2.ResultRow firstWhere(bool Function(_i2.ResultRow)? test,
          {_i2.ResultRow Function()? orElse}) =>
      (super.noSuchMethod(
          Invocation.method(#firstWhere, [test], {#orElse: orElse}),
          returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  _i2.ResultRow lastWhere(bool Function(_i2.ResultRow)? test,
          {_i2.ResultRow Function()? orElse}) =>
      (super.noSuchMethod(
          Invocation.method(#lastWhere, [test], {#orElse: orElse}),
          returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  _i2.ResultRow singleWhere(bool Function(_i2.ResultRow)? test,
          {_i2.ResultRow Function()? orElse}) =>
      (super.noSuchMethod(
          Invocation.method(#singleWhere, [test], {#orElse: orElse}),
          returnValue: _FakeResultRow_1()) as _i2.ResultRow);
  @override
  _i2.ResultRow elementAt(int? index) =>
      (super.noSuchMethod(Invocation.method(#elementAt, [index]),
          returnValue: _FakeResultRow_1()) as _i2.ResultRow);
}

/// A class which mocks [NavigatorObserver].
///
/// See the documentation for Mockito's code generation for more information.
class MockNavigatorObserver extends _i1.Mock implements _i9.NavigatorObserver {
  @override
  void didPush(_i9.Route<dynamic>? route, _i9.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPush, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didPop(_i9.Route<dynamic>? route, _i9.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didPop, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didRemove(
          _i9.Route<dynamic>? route, _i9.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(Invocation.method(#didRemove, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didReplace(
          {_i9.Route<dynamic>? newRoute, _i9.Route<dynamic>? oldRoute}) =>
      super.noSuchMethod(
          Invocation.method(
              #didReplace, [], {#newRoute: newRoute, #oldRoute: oldRoute}),
          returnValueForMissingStub: null);
  @override
  void didStartUserGesture(
          _i9.Route<dynamic>? route, _i9.Route<dynamic>? previousRoute) =>
      super.noSuchMethod(
          Invocation.method(#didStartUserGesture, [route, previousRoute]),
          returnValueForMissingStub: null);
  @override
  void didStopUserGesture() =>
      super.noSuchMethod(Invocation.method(#didStopUserGesture, []),
          returnValueForMissingStub: null);
}

import 'package:account_managment/model/lov/AccountHoppyLOV.dart';
import 'package:account_managment/model/lov/AccountSexLOV.dart';
import 'package:account_managment/model/lov/AccountStatusLOV.dart';
import 'package:account_managment/model/lov/JobTypeLOV.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {

  int _id;
  String _firstName;
  String _lastName;
  JobTypeLOV _job;
  DateTime _bod;
  AccountSexLOV _sex;
  AccountStatusLOV _status;
  String _comment;
  double _power;
  Set<AccountHoppyLOV> _hoppies;

  Account.newBorn() {
    _id = null;
    _firstName = '';
    _lastName = '';
    _job = null;
    _bod = DateTime.now();
    _sex = AccountSexLOV.MALE;
    _status = AccountStatusLOV.ACTIVE;
    _comment = '';
    _power = 0.0;
    _hoppies = Set();
  }

  Account(this._firstName, this._lastName, this._job, this._bod, this._sex,
      this._status, this._hoppies, this._comment, this._power);

  Account.withId(this._id, this._firstName, this._lastName, this._job,
      this._bod, this._sex, this._status, this._hoppies, this._comment, this._power);

  int get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  JobTypeLOV get job => _job;
  DateTime get bod => _bod;
  AccountSexLOV get sex => _sex;
  AccountStatusLOV get status => _status;
  String get comment => _comment;
  Set<AccountHoppyLOV> get hoppies => _hoppies;
  double get power => _power;

  void set firstName(String fn) {
    this._firstName = fn;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'firstName': _firstName,
      'lastName': _lastName,
      'job': _job.code,
      'bod': _bod.millisecondsSinceEpoch,
      'sex': _sex.code,
      'active': _status.code,
      'comment': _comment,
      'power': _power,
    };
  }

  Account.fromMap(Map<String, dynamic> m) {
    this._id = m['id'];
    this._firstName = m['firstName'];
    this._lastName = m['lastName'];
    this._job = JobTypeLOV.fromCode(m['job']);
    this._bod = DateTime.fromMillisecondsSinceEpoch(m['bod']);
    this._sex = AccountSexLOV.fromCode(m['sex']);
    this._status = AccountStatusLOV.fromCode(m['active']);
    this._comment = m['comment'];
    this._power = m['power'];
    this._hoppies = Set();
  }

//  Account.fromDocument(DocumentSnapshot ds) {
//    this._id = ds['id'];
//    this._firstName = ds['firstName'];
//    this._lastName = ds['lastName'];
//    this._job = JobTypeLOV.fromCode(ds['job']);
//    this._bod = DateTime.fromMillisecondsSinceEpoch(ds['bod']);
//    this._sex = AccountSexLOV.fromCode(ds['sex']);
//    this._status = AccountStatusLOV.fromCode(ds['active']);
//    this._comment = ds['comment'];
//    this._power = ds['power'];
//    this._hoppies = Set();
//  }

  @override
  String toString() {
    return "Account => {"
        "id:$_id, "
        "firstName:$_firstName, "
        "lastName: $_lastName, "
        "job: $_job, "
        "bod:$_bod, "
        "sex:$_sex, "
        "active:$_status, "
        "comment:$_comment, "
        "power:$_power}";
  }
}

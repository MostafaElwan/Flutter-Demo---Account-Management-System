class AccountSexLOV {

  final int _code;
  final String _desc;

  const AccountSexLOV._internal(this._code, this._desc);

  static const MALE = const AccountSexLOV._internal(1, 'Male');
  static const FEMALE = const AccountSexLOV._internal(0, 'Female');

  int get code => _code;
  String get desc => _desc;

  static AccountSexLOV fromCode(code) {
    switch(code) {
      case 0:
        return FEMALE;
      case 1:
        return MALE;
    }
  }

  static List<AccountSexLOV> get all => [
    MALE,
    FEMALE,
  ];
}
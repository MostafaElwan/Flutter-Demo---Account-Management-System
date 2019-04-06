class AccountStatusLOV {

  final int _code;
  final String _desc;

  const AccountStatusLOV._internal(this._code, this._desc);

  static const ACTIVE = const AccountStatusLOV._internal(1, 'Active');
  static const INACTIVE = const AccountStatusLOV._internal(0, 'Inactive');

  int get code => _code;
  String get desc => _desc;

  static AccountStatusLOV fromCode(code) {
    switch(code) {
      case 0:
        return INACTIVE;
      case 1:
        return ACTIVE;
    }
  }

  static List<AccountStatusLOV> get all => [
    ACTIVE,
    INACTIVE,
  ];
}
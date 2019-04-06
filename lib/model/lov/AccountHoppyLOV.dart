class AccountHoppyLOV {

  final int _code;
  final String _desc;

  const AccountHoppyLOV._internal(this._code, this._desc);

  static const READING = const AccountHoppyLOV._internal(1, 'Reading');
  static const WRITING = const AccountHoppyLOV._internal(2, 'Writing');
  static const SINGING = const AccountHoppyLOV._internal(3, 'Singing');
  static const DRAWING = const AccountHoppyLOV._internal(4, 'Drawing');

  int get code => _code;
  String get desc => _desc;

  static AccountHoppyLOV fromCode(code) {
    switch(code) {
      case 1:
        return READING;
      case 2:
        return WRITING;
      case 3:
        return SINGING;
      case 4:
        return DRAWING;

    }
  }

  static List<AccountHoppyLOV> get all => [
    READING,
    WRITING,
    SINGING,
    DRAWING,
  ];
}
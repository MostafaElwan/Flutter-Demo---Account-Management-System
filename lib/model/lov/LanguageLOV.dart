class LanguageLOV {

//  static final String PREF_NAME = 'LOCALE_LANG';

  final int _code;
  final String _desc;
  final String _shdes;

  const LanguageLOV._internal(this._code, this._desc, this._shdes);

  static const ARABIC = const LanguageLOV._internal(1, 'Arabic', 'ar');
  static const ENGLISH = const LanguageLOV._internal(0, 'English', 'en');

  int get code => _code;
  String get desc => _desc;
  String get shdes => _shdes;

  static LanguageLOV fromCode(code) {
    switch(code) {
      case 0:
        return ENGLISH;
      case 1:
        return ARABIC;
    }
  }

  static LanguageLOV fromShdes(shdes) {
    switch(shdes) {
      case 'en':
        return ENGLISH;
      case 'ar':
        return ARABIC;
    }
  }

  static List<LanguageLOV> get all => [
    ENGLISH,
    ARABIC,
  ];
}
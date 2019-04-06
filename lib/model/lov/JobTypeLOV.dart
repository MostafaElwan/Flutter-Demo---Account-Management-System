class JobTypeLOV {

  final int _code;
  final String _desc;

  const JobTypeLOV._internal(this._code, this._desc);

  static const JUNIOR = const JobTypeLOV._internal(1, 'Junior');
  static const SENIOR = const JobTypeLOV._internal(2, 'Senior');
  static const TEAM_LEADER = const JobTypeLOV._internal(3, 'Team Leader');
  static const TECHNICAL_EXPERT = const JobTypeLOV._internal(4, 'Technical Expert');
  static const MANAGER = const JobTypeLOV._internal(5, 'Manager');

  int get code => _code;
  String get desc => _desc;

  static JobTypeLOV fromCode(code) {
    switch(code) {
      case 1:
        return JUNIOR;
      case 2:
        return SENIOR;
      case 3:
        return TEAM_LEADER;
      case 4:
        return TECHNICAL_EXPERT;
      case 5:
        return MANAGER;

    }
  }

  static List<JobTypeLOV> get all => [
    JUNIOR,
    SENIOR,
    TEAM_LEADER,
    TECHNICAL_EXPERT,
    MANAGER,
  ];
}
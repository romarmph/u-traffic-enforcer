class IssuedViolation {
  final String violationID;
  final String violation;
  final int offense;
  final int fine;
  final String penalty;
  final bool isBigVehicle;

  const IssuedViolation({
    required this.violationID,
    required this.violation,
    required this.fine,
    this.offense = 1,
    this.penalty = "",
    this.isBigVehicle = false,
  });

  factory IssuedViolation.fromJson(Map<String, dynamic> json) {
    return IssuedViolation(
      violationID: json['violationID'],
      violation: json['violation'],
      offense: json['offense'],
      fine: json['fine'],
      penalty: json['penalty'],
      isBigVehicle: json['isBigVehicle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'violationID': violationID,
      'violation': violation,
      'offense': offense,
      'fine': fine,
      'penalty': penalty,
      'isBigVehicle': isBigVehicle,
    };
  }
}

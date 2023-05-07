class HealthData {
  final double height;
  final double weight;
  final String bloodType;
  final double bmi;
  final String vaccinationStatus;
  final DateTime date;
  final bool isDarkMode;

  const HealthData({
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.bmi,
    required this.vaccinationStatus,
    required this.date,
    required this.isDarkMode,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      height: json['height'],
      weight: json['weight'],
      bloodType: json['bloodType'],
      bmi: json['bmi'],
      vaccinationStatus: json['vaccinationStatus'],
      date: DateTime.parse(json['date']),
      isDarkMode: json['isDarkMode'],
    );
  }

  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'bloodType': bloodType,
        'bmi': bmi,
        'vaccinationStatus': vaccinationStatus,
        'date': date.toIso8601String(),
        'isDarkMode': isDarkMode,
      };

  HealthData copyWith({
    double? height,
    double? weight,
    String? bloodType,
    double? bmi,
    String? vaccinationStatus,
    DateTime? date,
    bool? isDarkMode,
  }) =>
      HealthData(
        height: height ?? this.height,
        weight: weight ?? this.weight,
        bloodType: bloodType ?? this.bloodType,
        bmi: bmi ?? this.bmi,
        vaccinationStatus: vaccinationStatus ?? this.vaccinationStatus,
        date: date ?? DateTime.now(),
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}

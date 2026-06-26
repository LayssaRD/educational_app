class Course {
  final String courseId;
  final String name;
  final String description;
  final int duration;
  final DateTime updatedAt;
  final bool isSynced;

  Course({
    required this.courseId,
    required this.name,
    required this.description,
    required this.duration,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'name': name,
      'description': description,
      'duration': duration,
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseId: map['courseId'],
      name: map['name'],
      description: map['description'],
      duration: map['duration'],
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }

  Course copyWith({
    String? name,
    String? description,
    int? duration,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return Course(
      courseId: courseId,
      name: name ?? this.name,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}

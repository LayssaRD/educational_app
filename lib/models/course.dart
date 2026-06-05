class Course {
  final int? courseId;
  final String name;
  final String description;
  final int duration;

  Course({
    this.courseId,
    required this.name,
    required this.description,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'name': name,
      'description': description,
      'duration': duration,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseId: map['courseId'],
      name: map['name'],
      description: map['description'],
      duration: map['duration'],
    );
  }
}

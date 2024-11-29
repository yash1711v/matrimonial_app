class Interest {
  final String interestName;
  final List<String> hobbies;

  Interest({
    required this.interestName,
    required this.hobbies,
  });

  // Factory constructor to create an instance from JSON
  factory Interest.fromJson(Map<String, dynamic> json) {
    return Interest(
      interestName: json['interest_name'] as String,
      hobbies: List<String>.from(json['hobbies'] as List),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'interest_name': interestName,
      'hobbies': hobbies,
    };
  }
}

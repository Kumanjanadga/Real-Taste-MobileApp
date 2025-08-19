

class Usermodel {
  final String uid;

  Usermodel({required this.uid});

  // Factory constructor to create a Usermodel from a Map
  factory Usermodel.fromMap(Map<String, dynamic> data) {
    return Usermodel(
      uid: data['uid'] ?? '',
    );
  }

  // Method to convert Usermodel to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
    };
  }
}
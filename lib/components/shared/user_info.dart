
class UserInfo {
  // Private constructor
  UserInfo._();

  // Static instance
  static final UserInfo _instance = UserInfo._();

  // Factory method to provide access to the singleton instance
  factory UserInfo() {
    return _instance;
  }

  // Fields
  String? name;
  String? lastName;
  String? studentCode;
  String? degree;
  String? userPhotoBytes;

  // Optional: Method to clear all user info
  void clear() {
    name = null;
    lastName = null;
    studentCode = null;
    degree = null;
  }

  @override
  String toString() {
    return 'UserInfo(name: $name, lastName: $lastName, studentCode: $studentCode)';
  }
}

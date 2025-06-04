class UserModel {
  String email;
  String password;
  String? username; 
  String? confirmPassword; 

  UserModel({
    required this.email,
    required this.password,
    this.username, // Optional for login
    this.confirmPassword, // Optional for login
  });
}

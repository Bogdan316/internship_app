// abstract UserProfile,
class User {
  final String imagePath;
  final String name;
  final String email;
  final String about;
  final String repo;
  final bool isDarkMode;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.repo,
    required this.isDarkMode,
  });

  User copy({
    String? imagePath,
    String? name,
    String? email,
    String? about,
    String? repo,
    bool? isDarkTheme,
  }) =>
      User(
        imagePath: imagePath ?? this.imagePath,
        name: name ?? this.name,
        email: email ?? this.email,
        about: about ?? this.about,
        repo: repo ?? this.repo,
        isDarkMode: isDarkTheme ?? isDarkMode,
      );

  static User fromJson(Map<String, dynamic> json) => User(
    imagePath: json['imagePath'],
    name: json['name'],
    email: json['email'],
    about: json['about'],
    repo: json['repo'],
    isDarkMode: json['isDarkMode'],
  );

  Map<String, dynamic> toJson() => {
      'imagePath': imagePath,
      'name': name,
      'email': email,
      'about': about,
      'isDarkMode': isDarkMode,
  };
}

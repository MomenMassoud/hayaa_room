int calculateAge(String birthdateString) {
  List<String> parts = birthdateString.split('/');
  int birthYear = int.parse(parts[0]);
  int birthMonth = int.parse(parts[1]);
  int birthDay = int.parse(parts[2]);

  DateTime birthdate = DateTime(birthYear, birthMonth, birthDay);

  DateTime now = DateTime.now();
  int age = now.year - birthdate.year;

  // Check if the current date is before the birthdate in the current year
  bool isBeforeBirthday = now.month < birthdate.month ||
      (now.month == birthdate.month && now.day < birthdate.day);

  // Subtract 1 from the age if the current date is before the birthdate
  if (isBeforeBirthday) {
    age--;
  }

  return age;
}

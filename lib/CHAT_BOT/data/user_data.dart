class UserData {
  static String age = '';
  // Health Analysis Inputs
  static String glucose = ''; // mg/dL
  static String bmi = ''; // Body Mass Index
  static String diabetesPedigreeFunction = ''; // Family History Risk
  static String pregnancies = ''; // Number of pregnancies
  static String bloodPressure = ''; // mm Hg
  static String hba1cLevel = ''; // %

  // Helper to validate if all fields are filled
  static bool isComplete() {
    return glucose.isNotEmpty &&
        bmi.isNotEmpty &&
        diabetesPedigreeFunction.isNotEmpty &&
        pregnancies.isNotEmpty &&
        bloodPressure.isNotEmpty &&
        hba1cLevel.isNotEmpty &&
        age.isNotEmpty ;
  }
}

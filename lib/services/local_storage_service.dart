import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ✅ حفظ بيانات المستخدم بعد التسجيل
  static Future<void> saveUserData({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _prefs.setString('fullName', fullName);
    await _prefs.setString('email', email);
    await _prefs.setString('password', password);
    await _prefs.setBool('isLoggedIn', true);
  }

  // ✅ حفظ بيانات التحاليل بعد إدخالها
  static Future<void> saveHealthData({
    required String glucose,
    required String bmi,
    required String age,
    required String diabetesPedigreeFunction,
    required String pregnancies,
    required String bloodPressure,
    required String hba1cLevel,
  }) async {
    await _prefs.setString('glucose', glucose);
    await _prefs.setString('bmi', bmi);
    await _prefs.setString('age', age);
    await _prefs.setString('diabetesPedigreeFunction', diabetesPedigreeFunction);
    await _prefs.setString('pregnancies', pregnancies);
    await _prefs.setString('bloodPressure', bloodPressure);
    await _prefs.setString('hba1cLevel', hba1cLevel);
  }

  // ✅ تحديث بيانات الاسم والإيميل (لو المستخدم عدلهم في Profile)
  static Future<void> updateProfile({
    required String fullName,
    required String email,
  }) async {
    await _prefs.setString('fullName', fullName);
    await _prefs.setString('email', email);
  }

  // ✅ Getter لاسترجاع الداتا

  static String? get fullName => _prefs.getString('fullName');
  static String? get email => _prefs.getString('email');
  static String? get password => _prefs.getString('password');

  static String? get glucose => _prefs.getString('glucose');
  static String? get bmi => _prefs.getString('bmi');
  static String? get age => _prefs.getString('age');
  static String? get diabetesPedigreeFunction => _prefs.getString('diabetesPedigreeFunction');
  static String? get pregnancies => _prefs.getString('pregnancies');
  static String? get bloodPressure => _prefs.getString('bloodPressure');
  static String? get hba1cLevel => _prefs.getString('hba1cLevel');

  static bool get isLoggedIn => _prefs.getBool('isLoggedIn') ?? false;

  // ✅ تسجيل خروج
  static Future<void> logout() async {
    await _prefs.clear();
  }
}

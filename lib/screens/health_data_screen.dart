import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/local_storage_service.dart';
import '../CHAT_BOT/services/gemini_service.dart'; // ✅ عشان نستدعي Gemini API
import 'home_screen.dart';

class HealthDataScreen extends StatefulWidget {
  const HealthDataScreen({super.key});

  @override
  State<HealthDataScreen> createState() => _HealthDataScreenState();
}

class _HealthDataScreenState extends State<HealthDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController glucoseController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController diabetesPedigreeFunctionController = TextEditingController();
  final TextEditingController pregnanciesController = TextEditingController();
  final TextEditingController bloodPressureController = TextEditingController();
  final TextEditingController hba1cLevelController = TextEditingController();

  String result = '';

  Future<void> _checkDiabetes() async {
    if (_formKey.currentState!.validate()) {
      // ✅ حفظ البيانات
      await LocalStorageService.saveHealthData(
        glucose: glucoseController.text,
        bmi: bmiController.text,
        age: ageController.text,
        diabetesPedigreeFunction: diabetesPedigreeFunctionController.text,
        pregnancies: pregnanciesController.text,
        bloodPressure: bloodPressureController.text,
        hba1cLevel: hba1cLevelController.text,
      );

      // ✅ تجهيز الداتا لإرسالها لـ Gemini API
      var data = [
        {
          "age": ageController.text,
          "glucose": glucoseController.text,
          "bmi": bmiController.text,
          "diabetesPedigreeFunction": diabetesPedigreeFunctionController.text,
          "pregnancies": pregnanciesController.text,
          "bloodPressure": bloodPressureController.text,
          "hba1cLevel": hba1cLevelController.text,
        }
      ];

      // ✅ استدعاء Gemini API
      final geminiResult = await GeminiService.sendQuery(
        data: data,
        userQuery: 'Analyze the diabetes risk based on this health data.',
        systemContext: '''
You are a professional diabetes doctor.
Analyze the patient's medical test results carefully.
Then give a clear preliminary diagnosis about the probability of diabetes in a SHORT form.
Just say: (You have Diabetes or you do not have Diabetes) + (percentage risk).
In English only, no extra details.
''',
        responseFormat: '',
      );

      setState(() {
        result = geminiResult ?? 'No response received.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Health Data',
          style: TextStyle(color: AppColors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                buildInputField(label: 'Glucose', controller: glucoseController, hintText: 'e.g. 120'),
                const SizedBox(height: 16),
                buildInputField(label: 'BMI', controller: bmiController, hintText: 'e.g. 25.5'),
                const SizedBox(height: 16),
                buildInputField(label: 'Age', controller: ageController, hintText: 'e.g. 30'),
                const SizedBox(height: 16),
                buildInputField(label: 'Diabetes Pedigree Function', controller: diabetesPedigreeFunctionController, hintText: 'e.g. 0.5'),
                const SizedBox(height: 16),
                buildInputField(label: 'Pregnancies', controller: pregnanciesController, hintText: 'e.g. 2'),
                const SizedBox(height: 16),
                buildInputField(label: 'Blood Pressure', controller: bloodPressureController, hintText: 'e.g. 80'),
                const SizedBox(height: 16),
                buildInputField(label: 'HbA1c Level', controller: hba1cLevelController, hintText: 'e.g. 5.8'),
                const SizedBox(height: 32),

                // ✅ زرار Check Diabetes
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _checkDiabetes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Check Diabetes', style: AppTextStyles.button),
                  ),
                ),

                const SizedBox(height: 32),

                // ✅ خانة نتيجة التشخيص
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Result',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Text(
                    result.isNotEmpty ? result : 'No result yet.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField({required String label, required TextEditingController controller, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}

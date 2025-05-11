import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../services/local_storage_service.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController glucoseController;
  late TextEditingController bmiController;
  late TextEditingController ageController;
  late TextEditingController diabetesPedigreeFunctionController;
  late TextEditingController pregnanciesController;
  late TextEditingController bloodPressureController;
  late TextEditingController hba1cLevelController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: LocalStorageService.fullName ?? '');
    emailController = TextEditingController(text: LocalStorageService.email ?? '');
    glucoseController = TextEditingController(text: LocalStorageService.glucose ?? '');
    bmiController = TextEditingController(text: LocalStorageService.bmi ?? '');
    ageController = TextEditingController(text: LocalStorageService.age ?? '');
    diabetesPedigreeFunctionController = TextEditingController(text: LocalStorageService.diabetesPedigreeFunction ?? '');
    pregnanciesController = TextEditingController(text: LocalStorageService.pregnancies ?? '');
    bloodPressureController = TextEditingController(text: LocalStorageService.bloodPressure ?? '');
    hba1cLevelController = TextEditingController(text: LocalStorageService.hba1cLevel ?? '');
  }

  Future<void> _saveProfileDetails() async {
    if (_formKey.currentState!.validate()) {
      await LocalStorageService.updateProfile(
        fullName: nameController.text,
        email: emailController.text,
      );

      await LocalStorageService.saveHealthData(
        glucose: glucoseController.text,
        bmi: bmiController.text,
        age: ageController.text,
        diabetesPedigreeFunction: diabetesPedigreeFunctionController.text,
        pregnancies: pregnanciesController.text,
        bloodPressure: bloodPressureController.text,
        hba1cLevel: hba1cLevelController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile Details', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField(label: 'Full Name', controller: nameController),
              const SizedBox(height: 16),
              buildInputField(label: 'Email', controller: emailController),
              const SizedBox(height: 16),
              buildInputField(label: 'Glucose', controller: glucoseController),
              const SizedBox(height: 16),
              buildInputField(label: 'BMI', controller: bmiController),
              const SizedBox(height: 16),
              buildInputField(label: 'Age', controller: ageController),
              const SizedBox(height: 16),
              buildInputField(label: 'Diabetes Pedigree Function', controller: diabetesPedigreeFunctionController),
              const SizedBox(height: 16),
              buildInputField(label: 'Pregnancies', controller: pregnanciesController),
              const SizedBox(height: 16),
              buildInputField(label: 'Blood Pressure', controller: bloodPressureController),
              const SizedBox(height: 16),
              buildInputField(label: 'HbA1c Level', controller: hba1cLevelController),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveProfileDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Changes', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField({required String label, required TextEditingController controller}) {
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
            hintText: 'Enter $label...',
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../CHAT_BOT/services/gemini_service.dart';
import '../services/local_storage_service.dart';
import 'home_screen.dart';

class DiabetesChatgpt extends StatefulWidget {
  const DiabetesChatgpt({super.key});

  @override
  State<DiabetesChatgpt> createState() => _DiabetesChatgpt();
}

class _DiabetesChatgpt extends State<DiabetesChatgpt> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  bool _isConsultLoading = false;

  // ✅ استدعاء لإرسال سؤال المستخدم الحر
  Future<void> _sendUserQuestion() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    final result = await GeminiService.sendQuery(
      data: [],
      userQuery: _controller.text,
      systemContext: '''
You are a professional diabetes doctor.
Answer the user's question clearly and professionally in short English and arabic sentences.
''',
      responseFormat: '',
    );

    setState(() {
      _isLoading = false;
      _controller.clear();
      _response = result ?? 'No response received.';
    });
  }

  // ✅ استدعاء لإرسال بيانات التحاليل المحفوظة
  Future<void> _consultBasedOnData() async {
    setState(() => _isConsultLoading = true);

    var data = [
      {
        "age": LocalStorageService.age ?? '',
        "glucose": LocalStorageService.glucose ?? '',
        "bmi": LocalStorageService.bmi ?? '',
        "diabetesPedigreeFunction": LocalStorageService.diabetesPedigreeFunction ?? '',
        "pregnancies": LocalStorageService.pregnancies ?? '',
        "bloodPressure": LocalStorageService.bloodPressure ?? '',
        "hba1cLevel": LocalStorageService.hba1cLevel ?? '',
      }
    ];

    final result = await GeminiService.sendQuery(
      data: data,
      userQuery: 'Analyze the diabetes risk based on this health data.',
      systemContext: '''
You are a professional doctor specialized in diabetes diagnosis.

1. Start by analyzing the patient's provided medical test results and described symptoms in both Arabic and English in a SHORT form.
2. After gathering all the information, provide an initial short diagnosis clearly in both Arabic and English.
3. Then give a clear preliminary diagnosis about the probability of diabetes in a SHORT form based on the analysis in both Arabic and English.
4. just Say: (You have Diabetes or you do not have Diabetes) + (percentage risk) In English only.
Keep your response professional, clear, supportive, and concise, and brief.
Only pure text, no formatting or special characters.
''',
      responseFormat: '',

    );

    setState(() {
      _isConsultLoading = false;
      _response = result ?? 'No response received.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Chatbot', style: TextStyle(color: AppColors.white)),
        centerTitle: true,
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Row فيه TextField وزرار Send
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your symptoms or question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendUserQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ✅ زرار Consult الكبير
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isConsultLoading ? null : _consultBasedOnData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isConsultLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Consult', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ عرض الرد بتاع Gemini
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  _response,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

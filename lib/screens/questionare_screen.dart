import 'package:book_zone/widgets/button_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  String _selectedPersonalityType = 'Adventurous';
  List<String> dislikes = [];
  List<String> likes = [];
  List<String> interestingGenres = [];

  final List<String> personalityTypes = [
    'Adventurous',
    'Intellectual',
    'Romantic',
    'Mysterious',
  ];

  final List<String> dislikeOptions = [
    'Poorly developed characters',
    'Slow pacing',
    'Predictable plot',
    'Lack of depth',
  ];

  final List<String> likeOptions = [
    'Strong character development',
    'Engaging plot twists',
    'Rich descriptive language',
    'Thought-provoking themes',
  ];

  final List<String> genreOptions = [
    'Mystery',
    'Romance',
    'Science Fiction',
    'Fantasy',
    'Thriller',
    'Historical Fiction',
    'Biography',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questionnaire'),
        backgroundColor: const Color(0xFF084B8A), // Rich Blue
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s your personality type?',
                style: TextStyle(fontSize: 16.sp),
              ),
              DropdownButton<String>(
                value: _selectedPersonalityType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPersonalityType = newValue!;
                  });
                },
                items: <String>[
                  'Adventurous',
                  'Intellectual',
                  'Romantic',
                  'Mysterious',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0.h),
              Text(
                'What do you hate the most in a book?',
                style: TextStyle(fontSize: 16.sp),
              ),
              Wrap(
                spacing: 8.0.sp,
                children: dislikeOptions.map((String option) {
                  return FilterChip(
                    label: Text(option),
                    selected: dislikes.contains(option),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          dislikes.add(option);
                        } else {
                          dislikes.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0.h),
              Text(
                'What do you like the most in a book?',
                style: TextStyle(fontSize: 16.sp),
              ),
              Wrap(
                spacing: 8.0.sp,
                children: likeOptions.map((String option) {
                  return FilterChip(
                    label: Text(option),
                    selected: likes.contains(option),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          likes.add(option);
                        } else {
                          likes.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0.h),
              Text(
                'What are the genres you find the most interesting?',
                style: TextStyle(fontSize: 16.sp),
              ),
              Wrap(
                spacing: 8.0.sp,
                children: genreOptions.map((String option) {
                  return FilterChip(
                    label: Text(option),
                    selected: interestingGenres.contains(option),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          interestingGenres.add(option);
                        } else {
                          interestingGenres.remove(option);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0.h),
              Center(
                child: SizedBox(
                  width: 200.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: saveQuestionnaireData,
                    style: buttonStyle,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveQuestionnaireData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    final questionnaireRef =
    FirebaseFirestore.instance.collection('questionnaires').doc(userId);

    try {
      await questionnaireRef.set({
        'personalityType': _selectedPersonalityType,
        'dislikes': dislikes,
        'likes': likes,
        'interestingGenres': interestingGenres,
      });

      print('Questionnaire data saved successfully!');
      // Navigate to the next screen or perform any desired action
      Navigator.pushReplacementNamed(context, 'login_screen');
    } catch (error) {
      print('Failed to save questionnaire data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save questionnaire data'),
        ),
      );
    }
  }
}

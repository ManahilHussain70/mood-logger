import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MoodLoggerScreen extends StatelessWidget {
  MoodLoggerScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> moods = [
    {'label': 'Happy', 'emoji': '😊', 'color': Colors.yellow},
    {'label': 'Sad', 'emoji': '😢', 'color': Colors.blue},
    {'label': 'Angry', 'emoji': '😠', 'color': Colors.red},
    {'label': 'Tired', 'emoji': '😴', 'color': Colors.grey},
    {'label': 'Excited', 'emoji': '🤩', 'color': Colors.purple},
  ];

  void _logMood(BuildContext context, String mood) {
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log your mood'),
          content: TextField(
            controller: messageController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Why are you feeling $mood?',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('mood_logs').add({
                  'mood': mood,
                  'message': messageController.text,
                  'timestamp': DateTime.now(),
                });
                Navigator.pop(context); // Close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '$mood saved with message!',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  ),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(
          'Mood Logger',
          style: TextStyle(
            fontFamily: 'Lobster',
            fontSize: 26,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          return Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _logMood(context, mood['label']);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: mood['color'],
                      radius: 25,
                      child: Text(
                        mood['emoji'],
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      mood['label'],
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

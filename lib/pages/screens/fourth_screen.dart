import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kyles_test_app/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FourthScreen extends StatelessWidget {
  FourthScreen({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;
  final TextEditingController _answerController = TextEditingController();

  Future<void> saveAnswer(BuildContext context, String answer) async {
    if (user != null) {
      final CollectionReference answersCollection =
          FirebaseFirestore.instance.collection('snake_answers');

      try {
        await answersCollection.add({
          'userId': user!.uid,
          'snake_answers': answer,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Answer saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save answer.')),
        );
      }
    }
  }

  Future<void> getHistoricalAverage(BuildContext context) async {
    final CollectionReference answersCollection =
        FirebaseFirestore.instance.collection('snake_answers');

    try {
      final QuerySnapshot querySnapshot = await answersCollection.get();
      final List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        int totalScore = 0;
        int documentCount = 0;

        for (final QueryDocumentSnapshot document in documents) {
          final dynamic documentData = document.data();

          if (documentData.containsKey('snake_answers')) {
            final dynamic snakeAnswersData = documentData['snake_answers'];

            if (snakeAnswersData is String) {
              final int? score = int.tryParse(snakeAnswersData);
              if (score != null) {
                totalScore += score;
                documentCount++;

                print('Score: $score');
              }
            }
          }
        }

        if (documentCount > 0) {
          final double averageScore = totalScore / documentCount;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Historical Average: $averageScore')),
          );
          print('Historical Average: $averageScore');
          return;
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No scores available.')),
      );
      print('No scores available.');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to retrieve scores.')),
      );
      print('Failed to retrieve scores: $e');
    }
  }

  Widget _questionWidget() {
    return const Text('How would you rate snakes out of 10?');
  }

  Widget _answerTextField() {
    return TextField(
      controller: _answerController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _saveButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final String answer = _answerController.text;
        saveAnswer(context, answer);
      },
      child: const Text('Submit Score'),
    );
  }

  Widget _historicalAverageButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getHistoricalAverage(context);
      },
      child: const Text('Get Historical Average'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fourth Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _questionWidget(),
            _answerTextField(),
            _saveButton(context),
            _historicalAverageButton(context),
          ],
        ),
      ),
    );
  }
}

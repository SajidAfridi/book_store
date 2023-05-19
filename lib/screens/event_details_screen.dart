import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../classes/event.dart';
import '../utils/app_colors.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  event.bookName,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colours.themeColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By ${event.authorName}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Last Date:',
                attributeValue: event.lastDate,
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Place:',
                attributeValue: event.place,
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Number of Seats:',
                attributeValue: event.numSeats.toString(),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              buildRegistrationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegistrationButtons(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Events').doc(event.eventNo).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final eventSnapshot = snapshot.data;
        final registeredUsers = List<String>.from(eventSnapshot!['registeredUsers']);
        final bool isRegistered = registeredUsers.contains(FirebaseAuth.instance.currentUser?.uid);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: isRegistered
                  ? () {
                unregisterEvent(context);
              }
                  : () {
                registerEvent(context);
              },
              child: Text(
                isRegistered ? 'Unregister' : 'Register',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        );
      },
    );
  }

  Future<void> registerEvent(BuildContext context) async {
    final registeredUsersRef =
    FirebaseFirestore.instance.collection('Events').doc(event.eventNo).collection('registered_users');
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Check if the user is already registered
      final snapshot = await registeredUsersRef.doc(user!.uid).get();
      if (snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You are already registered for this event.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Register the user
      await registeredUsersRef.doc(user.uid).set({});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registered successfully.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration failed. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> unregisterEvent(BuildContext context) async {
    final registeredUsersRef =
    FirebaseFirestore.instance.collection('Events').doc(event.eventNo).collection('registered_users');
    final user = FirebaseAuth.instance.currentUser;

    try {
      // Check if the user is registered
      final snapshot = await registeredUsersRef.doc(user!.uid).get();
      if (!snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You are not registered for this event.',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Unregister the user
      await registeredUsersRef.doc(user.uid).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unregistered successfully.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registration failed. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class AttributeText extends StatelessWidget {
  final String attributeName;
  final String attributeValue;

  const AttributeText({Key? key, required this.attributeName, required this.attributeValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attributeName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          attributeValue,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
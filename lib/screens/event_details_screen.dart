import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../classes/event.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isRegistered = false;

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus();
  }

  Future<void> checkRegistrationStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final registeredUsersRef = FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.event.eventNo)
        .collection('registered_users');

    final snapshot = await registeredUsersRef.doc(user.uid).get();
    setState(() {
      isRegistered = snapshot.exists;
    });
  }

  Future<void> registerEvent(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final registeredUsersRef = FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.event.eventNo)
        .collection('registered_users');

    try {
      // Check if the user is already registered
      final snapshot = await registeredUsersRef.doc(user.uid).get();
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

      setState(() {
        isRegistered = true;
        widget.event.numSeats--;
      });

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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final registeredUsersRef = FirebaseFirestore.instance
        .collection('Events')
        .doc(widget.event.eventNo)
        .collection('registered_users');

    try {
      // Check if the user is registered
      final snapshot = await registeredUsersRef.doc(user.uid).get();
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

      setState(() {
        isRegistered = false;
        widget.event.numSeats++;
      });

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
            'Unregistration failed. Please try again.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.event.bookName,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'By ${widget.event.authorName}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Last Date:',
                attributeValue: widget.event.lastDate,
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Place:',
                attributeValue: widget.event.place,
              ),
              const SizedBox(height: 16),
              AttributeText(
                attributeName: 'Number of Seats:',
                attributeValue: widget.event.numSeats.toString(),
              ),
              const SizedBox(height: 16),
              buildRegistrationButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRegistrationButtons(BuildContext context) {
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../classes/event.dart';

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  TextEditingController eventNoController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController bookNameController = TextEditingController();
  TextEditingController lastDateController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController numSeatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: eventNoController,
                decoration: const InputDecoration(
                  labelText: 'Event No',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: authorNameController,
                decoration: const InputDecoration(
                  labelText: 'Author Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: bookNameController,
                decoration: const InputDecoration(
                  labelText: 'Book Name',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: lastDateController,
                decoration: const InputDecoration(
                  labelText: 'Last Date',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: numSeatsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Seats',
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  createEvent();
                  Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createEvent() async {
    final event = Event(
      authorName: authorNameController.text,
      bookName: bookNameController.text,
      lastDate: lastDateController.text,
      place: placeController.text,
      numSeats: int.parse(numSeatsController.text),
      eventNo: '',
    );

    // Generate auto-incremented event number
    final CollectionReference eventsCollection =
    FirebaseFirestore.instance.collection('Events');
    final QuerySnapshot snapshot = await eventsCollection.get();
    final int nextEventNo = snapshot.size + 1;
    final String eventNo = nextEventNo.toString();

    // Save event to Firebase Firestore
    await eventsCollection.doc(eventNo).set({
      'eventNo': eventNo,
      'authorName': event.authorName,
      'bookName': event.bookName,
      'lastDate': event.lastDate,
      'place': event.place,
      'numSeats': event.numSeats,
      'registeredUsers': event.registeredUsers,
    });
  }
}

void navigateToCreateEventScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateEventScreen()),
  );
}

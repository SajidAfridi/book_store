import 'package:book_zone/utils/app_colors.dart';
import 'package:book_zone/utils/app_sizebox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../classes/event.dart';
import 'create_event.dart';
import 'event_details_screen.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildEventsList(),
          ),
          buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget buildEventsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Events').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = snapshot.data!.docs.map((DocumentSnapshot document) {
          return Event(
            eventNo: document['eventNo'],
            authorName: document['authorName'],
            bookName: document['bookName'],
            lastDate: document['lastDate'],
            place: document['place'],
            numSeats: document['numSeats'],
            registeredUsers: List<String>.from(document['registeredUsers']),
          );
        }).toList();

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            final event = events[index];
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.sp),
              child: ListTile(
                //isThreeLine: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.bookName,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    fixSizedBox10,
                    Text(
                      event.authorName,
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Seats: ${event.numSeats}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          navigateToEventDetailsScreen(context, event);
                        },
                        child: Text(
                          'Details',
                          style: TextStyle(
                              color: Colours.loginButtonColor, fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              navigateToCreateEventScreen(context);
            },
            child: const Text('Create Event'),
          ),
        ],
      ),
    );
  }

  void navigateToEventDetailsScreen(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EventDetailsScreen(event: event)),
    );
  }

  void registerEvent(Event event) {
    // Add user ID to the list of registered users
    event.registeredUsers.add('user_id_here');

    // Decrement the number of available seats
    if (event.numSeats > 0) {
      event.numSeats--;
    }

    // Save the updated event to Firebase Firestore
    FirebaseFirestore.instance
        .collection('Events')
        .doc(event.eventNo)
        .set(event.toMap());
  }

  void unregisterEvent(Event event) {
    // Remove user ID from the list of registered users
    event.registeredUsers.remove('user_id_here');

    // Increment the number of available seats
    event.numSeats++;

    // Save the updated event to Firebase Firestore
    FirebaseFirestore.instance
        .collection('Events')
        .doc(event.eventNo)
        .set(event.toMap());
  }
}

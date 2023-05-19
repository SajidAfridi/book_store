class Event {
  final String eventNo;
  final String authorName;
  final String bookName;
  final String lastDate;
  final String place;
  int numSeats;
  List<String> registeredUsers;

  Event({
    required this.eventNo,
    required this.authorName,
    required this.bookName,
    required this.lastDate,
    required this.place,
    required this.numSeats,
    List<String>? registeredUsers,
  }) : registeredUsers = registeredUsers ?? [];

  bool isFull() {
    return registeredUsers.length >= numSeats;
  }

  bool registerUser(String user) {
    if (!isFull() && !registeredUsers.contains(user)) {
      registeredUsers.add(user);
      return true;
    }
    return false;
  }

  bool unregisterUser(String user) {
    if (registeredUsers.contains(user)) {
      registeredUsers.remove(user);
      return true;
    }
    return false;
  }

  String getRegistrationStatus(String user) {
    return registeredUsers.contains(user) ? 'Registered' : 'Unregistered';
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventNo: json['eventNo'],
      authorName: json['authorName'],
      bookName: json['bookName'],
      lastDate: json['lastDate'],
      place: json['place'],
      numSeats: json['numSeats'],
      registeredUsers: json['registeredUsers'] != null ? List<String>.from(json['registeredUsers']) : null,
    );
  }
  Event.fromMap(Map<String, dynamic> map)
      : eventNo = map['eventNo'],
        authorName = map['authorName'],
        bookName = map['bookName'],
        lastDate = map['lastDate'],
        place = map['place'],
        numSeats = map['numSeats'],
        registeredUsers = List<String>.from(map['registeredUsers'] ?? []);
  Map<String, dynamic> toMap() {
    return {
      'eventNo': eventNo,
      'authorName': authorName,
      'bookName': bookName,
      'lastDate': lastDate,
      'place': place,
      'numSeats': numSeats,
      'registeredUsers': registeredUsers,
    };
  }
}
class Event {
  final int id;
  final String title; // Diubah dari 'name'
  final String description;
  final String startDate; // Diubah dari 'date'
  final String location;
  final int maxAttendees; // Diubah dari 'maxParticipants'
  final int registrationsCount; // Diubah dari 'currentParticipants'
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.location,
    required this.maxAttendees,
    required this.registrationsCount,
    required this.category,
  });

  // Factory constructor untuk membuat instance Event dari JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    // Ekstrak tanggal dan waktu dari 'start_date'
    // Memberikan nilai default jika null untuk menghindari error
    final DateTime parsedDateTime = json['start_date'] != null
        ? DateTime.parse(json['start_date'])
        : DateTime.now();
    
    return Event(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title', // Menggunakan 'title'
      description: json['description'] ?? 'No Description',
      // Menggunakan 'start_date' dan memformatnya ke standar ISO 8601
      startDate: parsedDateTime.toIso8601String(),
      location: json['location'] ?? 'No Location',
      maxAttendees: json['max_attendees'] ?? 0, // Menggunakan 'max_attendees'
      registrationsCount: json['registrations_count'] ?? 0, // Menggunakan 'registrations_count'
      category: json['category'] ?? 'Uncategorized',
    );
  }
}

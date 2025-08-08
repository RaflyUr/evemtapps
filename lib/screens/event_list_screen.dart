import 'package:flutter/material.dart';
import 'package:event_manager/api/api_service.dart';
import 'package:event_manager/models/event.dart';
import 'package:event_manager/utils/session_manager.dart';
import 'package:intl/intl.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  late Future<List<Event>> _eventsFuture;
  
  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    try {
      final result = await ApiService.getEvents();
      // Memastikan 'success' adalah true dan 'data' tidak null
      if (result['success'] == true && result['data'] != null) {
        // Mengakses list event dari result['data']['events']
        final eventData = result['data']['events'];
        if (eventData is List) {
          // Mengubah setiap item JSON di list menjadi objek Event
          return eventData.map((json) => Event.fromJson(json)).toList();
        }
      }
      // Jika kondisi tidak terpenuhi, kembalikan list kosong
      return [];
    } catch (e) {
      // Handle error, termasuk jika token tidak valid (401)
      if (e.toString().contains('401')) {
         _logout();
      }
      // Lemparkan exception agar bisa ditangkap oleh FutureBuilder
      throw Exception('Failed to load events: $e');
    }
  }

  void _logout() async {
    await SessionManager.removeToken();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  void _refreshEvents() {
    setState(() {
      _eventsFuture = _fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshEvents,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final events = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              // Mengubah string tanggal dari model menjadi objek DateTime
              final dateTime = DateTime.parse(event.startDate).toLocal();
              // Memformat tanggal dan waktu untuk ditampilkan
              final formattedDate = DateFormat('d MMMM yyyy').format(dateTime);
              final formattedTime = DateFormat('HH:mm').format(dateTime);

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  // Menggunakan event.title
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(event.description),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('$formattedDate at $formattedTime'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(child: Text(event.location, overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                       const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.category, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(event.category),
                        ],
                      ),
                    ],
                  ),
                  // Menampilkan jumlah partisipan
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${event.registrationsCount}/${event.maxAttendees}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text('Joined'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman buat event dan refresh list jika berhasil
          Navigator.of(context).pushNamed('/create-event').then((value) {
            if (value == true) {
              _refreshEvents();
            }
          });
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Event',
      ),
    );
  }
}
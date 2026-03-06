import 'package:event_app/service/api_service.dart';
import 'package:flutter/material.dart';

class MyEventsScreen extends StatefulWidget {
  const MyEventsScreen({super.key});

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  List registeredEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMyEvents();
  }

  Future<void> loadMyEvents() async {
    setState(() => isLoading = true);
    final events = await ApiService.getMyRegisteredEvents();
    if (mounted) {
      setState(() {
        registeredEvents = events;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Registered Events")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : registeredEvents.isEmpty
          ? const Center(
              child: Text("You haven't registered for any events yet."),
            )
          : ListView.builder(
              itemCount: registeredEvents.length,
              itemBuilder: (context, index) {
                final event = registeredEvents[index];
                return Card(
                  child: ListTile(
                    title: Text(event["title"] ?? "No Title"),
                    subtitle: Text("Location: ${event["location"] ?? ""}"),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

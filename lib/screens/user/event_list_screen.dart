import 'package:event_app/provider/event_provider.dart';
import 'package:event_app/screens/user/event_detail_screen.dart';
import 'package:event_app/screens/user/my_events_screen.dart';
import 'package:event_app/screens/user/user_login_screen.dart';
import 'package:event_app/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListScreen extends StatelessWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);

    if (!provider.isLoaded && !provider.loading) {
      Future.microtask(() => provider.loadEvents());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Events")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Welcome User",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text("My Registered Events"),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyEventsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () async {
                await ApiService.logout();
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => UserLoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.events.length,
              itemBuilder: (context, index) {
                final event = provider.events[index];

                return Card(
                  child: ListTile(
                    title: Text(event["title"] ?? ""),
                    subtitle: Text(event["location"] ?? ""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

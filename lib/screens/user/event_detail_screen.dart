import 'package:event_app/service/api_service.dart';
import 'package:flutter/material.dart';

class EventDetailScreen extends StatefulWidget {
  final Map event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  void showRegistrationDialog() {
    final name = TextEditingController();
    final email = TextEditingController();
    final phone = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Register for Event"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                TextField(
                  controller: email,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (name.text.isEmpty ||
                    email.text.isEmpty ||
                    phone.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields required")),
                  );
                  return;
                }

                final data = {
                  "name": name.text,
                  "email": email.text,
                  "phone": phone.text,
                };

                final success = await ApiService.registerForEvent(
                  widget.event["id"].toString(),
                  data,
                );

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? "Registered Successfully"
                          : "Registration Failed",
                    ),
                  ),
                );
              },
              child: const Text("Register"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event["title"] ?? "")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date : ${widget.event["event_date"] ?? widget.event["date"] ?? "N/A"}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Location : ${widget.event["location"] ?? ""}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.event["description"] ?? ""),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: showRegistrationDialog,
                child: const Text("Register for Event"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

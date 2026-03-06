import 'package:event_app/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  final Map? event;

  const AddEventScreen({super.key, this.event});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final title = TextEditingController();
  final location = TextEditingController();
  final description = TextEditingController();
  final date = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      title.text = widget.event!["title"] ?? "";
      location.text = widget.event!["location"] ?? "";
      description.text = widget.event!["description"] ?? "";
      date.text = widget.event!["event_date"] ?? widget.event!["date"] ?? "";
    }
  }

  submitEvent(BuildContext context) async {
    final provider = Provider.of<EventProvider>(context, listen: false);
    Map data = {
      "title": title.text,
      "event_date": date.text,
      "location": location.text,
      "description": description.text,
    };

    if (widget.event != null) {
      final eventId = widget.event!["_id"] ?? widget.event!["id"];
      if (eventId != null) {
        await provider.updateEvent(eventId, data);
      }
    } else {
      await provider.addEvent(data);
    }

    
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? "Add Event" : "Edit Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: date,
                decoration: const InputDecoration(labelText: "Date"),
              ),
              TextField(
                controller: location,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => submitEvent(context),
                  child: Text(
                    widget.event == null ? "Save Event" : "Update Event",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

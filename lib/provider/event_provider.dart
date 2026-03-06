import 'package:event_app/service/api_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  List events = [];
  bool loading = false;
  bool isLoaded = false;

  Future loadEvents() async {
    loading = true;
    notifyListeners();

    events = await ApiService.getEvents();

    loading = false;
    isLoaded = true;
    notifyListeners();
  }

  Future addEvent(Map data) async {
    loading = true;
    notifyListeners();

    await ApiService.addEvent(data);
    await loadEvents();
  }

  Future updateEvent(String id, Map data) async {
    loading = true;
    notifyListeners();

    await ApiService.updateEvent(id, data);
    await loadEvents();
  }

  Future deleteEvent(String id) async {
    loading = true;
    notifyListeners();

    await ApiService.deleteEvent(id);
    await loadEvents();
  }
}

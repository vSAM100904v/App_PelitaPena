import 'package:flutter/cupertino.dart';

import '../model/appointment_request_model.dart';
import '../services/api_service.dart';

class AppointmentProvider with ChangeNotifier {
  List<AppointmentRequestModel> _appointments = [];

  List<AppointmentRequestModel> get appointments => _appointments;

  Future<void> fetchAppointments() async {
    _appointments = await APIService().fetchAppointments();
    notifyListeners();
  }

  Future<void> cancelAppointment(int id, String reason) async {
    await APIService().cancelAppointment(id, reason);
    await fetchAppointments();
    notifyListeners();
  }
}

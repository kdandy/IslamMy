kerawimport 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/prayer_schedule.dart';

class PrayerService {
  static const String baseUrl = 'https://api.myquran.com/v2';

  // Search city by name
  Future<List<City>> searchCity(String cityName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/kota/cari/$cityName'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          List<City> cities = [];
          for (var item in data['data']) {
            cities.add(City.fromJson(item));
          }
          return cities;
        }
      }
      return [];
    } catch (e) {
      print('Error searching city: $e');
      return [];
    }
  }

  // Get all cities
  Future<List<City>> getAllCities() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/kota/semua'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          List<City> cities = [];
          for (var item in data['data']) {
            cities.add(City.fromJson(item));
          }
          return cities;
        }
      }
      return [];
    } catch (e) {
      print('Error getting all cities: $e');
      return [];
    }
  }

  // Get prayer schedule for a city and date
  // date format: YYYY-MM-DD or YYYY/MM/DD
  Future<PrayerSchedule?> getPrayerSchedule(String cityId, String date) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sholat/jadwal/$cityId/$date'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true && data['data'] != null) {
          final scheduleData = data['data'];
          if (scheduleData['jadwal'] != null) {
            return PrayerSchedule.fromJson(scheduleData['jadwal']);
          }
        }
      }
      return null;
    } catch (e) {
      print('Error getting prayer schedule: $e');
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/city.dart';
import '../../models/prayer_schedule.dart';
import '../../services/prayer_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PrayerService _prayerService = PrayerService();
  final TextEditingController _searchController = TextEditingController();
  
  City? _selectedCity;
  PrayerSchedule? _prayerSchedule;
  List<City> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    // Set default city (Jakarta)
    _setDefaultCity();
  }

  void _setDefaultCity() async {
    setState(() => _isLoading = true);
    // Default to Jakarta (ID: 1301)
    _selectedCity = City(id: '1301', lokasi: 'Jakarta');
    await _loadPrayerSchedule();
    setState(() => _isLoading = false);
  }

  Future<void> _loadPrayerSchedule() async {
    if (_selectedCity == null) return;
    
    setState(() => _isLoading = true);
    final schedule = await _prayerService.getPrayerSchedule(
      _selectedCity!.id,
      _currentDate,
    );
    setState(() {
      _prayerSchedule = schedule;
      _isLoading = false;
    });
  }

  Future<void> _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);
    final results = await _prayerService.searchCity(query);
    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _selectCity(City city) {
    setState(() {
      _selectedCity = city;
      _searchResults = [];
      _searchController.clear();
    });
    _loadPrayerSchedule();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _prayerSchedule == null
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.red.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.mosque,
                            size: 50,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Jadwal Sholat Hari Ini',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _selectedCity?.lokasi ?? 'Pilih Lokasi',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _prayerSchedule?.tanggal ?? _currentDate,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search City
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cari Lokasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Cari kota (contoh: Jakarta, Bandung)',
                                prefixIcon: Icon(Icons.search, color: Colors.red),
                                suffixIcon: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.clear, color: Colors.grey),
                                        onPressed: () {
                                          _searchController.clear();
                                          setState(() {
                                            _searchResults = [];
                                          });
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.red, width: 2),
                                ),
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onChanged: (value) {
                                _searchCity(value);
                              },
                            ),
                            if (_isSearching)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Center(
                                  child: CircularProgressIndicator(color: Colors.red),
                                ),
                              ),
                            if (_searchResults.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                constraints: BoxConstraints(maxHeight: 200),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResults.length,
                                  itemBuilder: (context, index) {
                                    final city = _searchResults[index];
                                    return ListTile(
                                      dense: true,
                                      leading: Icon(Icons.location_city, color: Colors.red, size: 20),
                                      title: Text(
                                        city.lokasi,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      onTap: () => _selectCity(city),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Daftar Waktu Sholat
                    if (_prayerSchedule != null) ...[
                      _buildPrayerTimeCard('Subuh', _prayerSchedule!.subuh, Icons.wb_twilight, Colors.indigo),
                      _buildPrayerTimeCard('Dzuhur', _prayerSchedule!.dzuhur, Icons.wb_sunny, Colors.orange),
                      _buildPrayerTimeCard('Ashar', _prayerSchedule!.ashar, Icons.wb_cloudy, Colors.amber),
                      _buildPrayerTimeCard('Maghrib', _prayerSchedule!.maghrib, Icons.wb_twilight, Colors.deepOrange),
                      _buildPrayerTimeCard('Isya', _prayerSchedule!.isya, Icons.nightlight_round, Colors.purple),
                    ] else if (!_isLoading)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Center(
                            child: Text(
                              'Pilih lokasi untuk melihat jadwal sholat',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPrayerTimeCard(String prayer, String time, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.05)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          title: Text(
            prayer,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

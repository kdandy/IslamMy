import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _qiblaDirection;
  double? _currentHeading;
  Position? _currentPosition;
  bool _isLoading = true;
  String _statusMessage = 'Memuat...';
  bool _hasPermissions = false;
  bool _isDesktopPlatform = false;
  StreamSubscription<CompassEvent>? _compassSubscription;
  DateTime? _lastLocationUpdate;

  // Koordinat Ka'bah di Mekah
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  @override
  void initState() {
    super.initState();
    _isDesktopPlatform = Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    _initializeQibla();
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeQibla() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Memeriksa izin...';
    });

    // Memeriksa dan meminta izin
    bool permissionsGranted = await _checkAndRequestPermissions();
    
    if (!permissionsGranted) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Izin lokasi dan sensor diperlukan';
        _hasPermissions = false;
      });
      return;
    }

    setState(() {
      _hasPermissions = true;
      _statusMessage = 'Mendapatkan lokasi...';
    });

    // Mendapatkan lokasi
    await _getCurrentLocation();

    // Memulai compass listener
    _startCompassListener();
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      // Memeriksa apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _statusMessage = 'Layanan lokasi tidak aktif';
        });
        return false;
      }

      // Memeriksa izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _statusMessage = 'Izin lokasi ditolak';
          });
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _statusMessage = 'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.';
        });
        return false;
      }

      return true;
    } catch (e) {
      setState(() {
        _statusMessage = 'Error memeriksa izin: $e';
      });
      return false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _qiblaDirection = _calculateQiblaDirection(
          position.latitude,
          position.longitude,
        );
        _lastLocationUpdate = DateTime.now();
        _statusMessage = 'Lokasi ditemukan';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Gagal mendapatkan lokasi: $e';
      });
    }
  }

  Future<void> _refreshLocation() async {
    setState(() {
      _statusMessage = 'Memperbarui lokasi...';
    });
    await _getCurrentLocation();
  }

  void _startCompassListener() {
    // Cek apakah platform mendukung compass
    if (Platform.isAndroid || Platform.isIOS) {
      // Realtime compass untuk mobile
      _compassSubscription = FlutterCompass.events?.listen((event) {
        if (event.heading != null) {
          setState(() {
            _currentHeading = event.heading;
            _isLoading = false;
          });
        }
      });
    } else {
      // Untuk platform yang tidak mendukung compass (macOS, Windows, Linux, Web)
      // Gunakan heading 0 (utara) sebagai default
      setState(() {
        _currentHeading = 0;
        _isLoading = false;
      });
    }
  }

  double _calculateQiblaDirection(double userLat, double userLon) {
    // Mengkonversi derajat ke radian
    double userLatRad = _toRadians(userLat);
    double userLonRad = _toRadians(userLon);
    double kaabaLatRad = _toRadians(kaabaLatitude);
    double kaabaLonRad = _toRadians(kaabaLongitude);

    // Menghitung bearing ke Ka'bah
    double dLon = kaabaLonRad - userLonRad;
    
    double y = math.sin(dLon) * math.cos(kaabaLatRad);
    double x = math.cos(userLatRad) * math.sin(kaabaLatRad) -
        math.sin(userLatRad) * math.cos(kaabaLatRad) * math.cos(dLon);
    
    double bearing = math.atan2(y, x);
    
    // Mengkonversi radian ke derajat
    double bearingDegrees = _toDegrees(bearing);
    
    // Normalisasi ke 0-360
    return (bearingDegrees + 360) % 360;
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  double _getRotationAngle() {
    if (_qiblaDirection == null || _currentHeading == null) {
      return 0;
    }
    // Menghitung sudut rotasi untuk compass
    return (_qiblaDirection! - _currentHeading!);
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Arah Kiblat'),
            if (!_isDesktopPlatform && _compassSubscription != null && !_isLoading) ...[
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.fiber_manual_record, size: 8, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'REALTIME',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_hasPermissions && !_isLoading) {
      return _buildPermissionDenied();
    }

    if (_isLoading) {
      return _buildLoading();
    }

    return _buildCompass();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            _statusMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Izin Diperlukan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () async {
                // Coba request permission lagi
                await _initializeQibla();
              },
              icon: Icon(Icons.refresh),
              label: Text('Minta Izin Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _initializeQibla,
              child: Text('Coba Lagi'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Info lokasi
          if (_currentPosition != null) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[100]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Lokasi Anda',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Lat: ${_currentPosition!.latitude.toStringAsFixed(4)}°',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Text(
                    'Lon: ${_currentPosition!.longitude.toStringAsFixed(4)}°',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  if (_lastLocationUpdate != null) ...[
                    SizedBox(height: 8),
                    Text(
                      'Update: ${_formatTime(_lastLocationUpdate!)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _refreshLocation,
                    icon: Icon(Icons.refresh, size: 16),
                    label: Text('Refresh Lokasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      textStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
          
          // Compass
          Center(
            child: Container(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Compass background
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  // Compass marks
                  CustomPaint(
                    size: Size(280, 280),
                    painter: CompassPainter(),
                  ),
                  // Rotating Qibla indicator
                  if (_qiblaDirection != null && _currentHeading != null)
                    Transform.rotate(
                      angle: _toRadians(_getRotationAngle()),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation,
                            size: 80,
                            color: Colors.red,
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Kiblat',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Direction info
          if (_qiblaDirection != null) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Arah Kiblat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${_qiblaDirection!.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _getCardinalDirection(_qiblaDirection!),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 20),
          
          // Manual rotation control for desktop platforms
          if (_isDesktopPlatform && _currentHeading != null) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Rotasi Manual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentHeading = (_currentHeading! - 10) % 360;
                          });
                        },
                        icon: Icon(Icons.rotate_left),
                        iconSize: 32,
                        color: Colors.red,
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${_currentHeading!.toStringAsFixed(0)}°',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentHeading = (_currentHeading! + 10) % 360;
                          });
                        },
                        icon: Icon(Icons.rotate_right),
                        iconSize: 32,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
          
          // Instructions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                SizedBox(height: 8),
                Text(
                  _isDesktopPlatform
                      ? 'Gunakan tombol rotasi untuk menyesuaikan arah kompas Anda'
                      : 'Pegang perangkat Anda secara mendatar dan putar hingga panah menunjuk ke arah atas',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  String _getCardinalDirection(double bearing) {
    const List<String> directions = [
      'Utara', 'Timur Laut', 'Timur', 'Tenggara',
      'Selatan', 'Barat Daya', 'Barat', 'Barat Laut'
    ];
    
    int index = ((bearing + 22.5) / 45).floor() % 8;
    return directions[index];
  }
}

// Custom painter untuk menggambar compass marks
class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw outer circle
    canvas.drawCircle(center, radius, paint);

    // Draw cardinal direction marks
    final markPaint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 360; i += 30) {
      final angle = (i - 90) * math.pi / 180;
      final isCardinal = i % 90 == 0;
      
      markPaint.color = isCardinal ? Colors.red : Colors.grey[400]!;
      
      final startRadius = radius - (isCardinal ? 20 : 10);
      final endRadius = radius;
      
      final start = Offset(
        center.dx + startRadius * math.cos(angle),
        center.dy + startRadius * math.sin(angle),
      );
      
      final end = Offset(
        center.dx + endRadius * math.cos(angle),
        center.dy + endRadius * math.sin(angle),
      );
      
      canvas.drawLine(start, end, markPaint);
    }

    // Draw cardinal letters
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final cardinals = ['U', 'T', 'S', 'B'];
    for (int i = 0; i < 4; i++) {
      final angle = (i * 90 - 90) * math.pi / 180;
      final textRadius = radius - 35;
      
      textPainter.text = TextSpan(
        text: cardinals[i],
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      );
      
      textPainter.layout();
      
      final offset = Offset(
        center.dx + textRadius * math.cos(angle) - textPainter.width / 2,
        center.dy + textRadius * math.sin(angle) - textPainter.height / 2,
      );
      
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

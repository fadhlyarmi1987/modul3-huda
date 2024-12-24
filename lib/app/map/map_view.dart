import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart'; // Tambahkan dependensi ini

class MapPage extends StatefulWidget {
  final Function(String) onLocationSelected; // Callback untuk mengirimkan lokasi
  MapPage({required this.onLocationSelected}); // Menerima callback

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      _getCurrentLocation();
    } else if (permission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Akses lokasi diperlukan untuk menggunakan fitur ini."),
      ));
    } else if (permission.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
      _mapController.move(_currentPosition!, 14.0);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk melakukan reverse geocoding
  Future<void> _getAddressFromCoordinates(LatLng latLng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      // Menyusun alamat dengan kecamatan dan kota
      String address = "${placemark.street}, ${placemark.locality ?? 'Kota tidak ditemukan'},${placemark.subLocality}, ${placemark.administrativeArea}";
      widget.onLocationSelected(address); // Kirimkan alamat ke HomeView
    }
  } catch (e) {
    print("Error getting address: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Page"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _currentPosition,
                    zoom: 13.0,
                    onTap: (tapPosition, point) {
                      _getAddressFromCoordinates(point); // Dapatkan alamat saat tap di peta
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentPosition!,
                          width: 40.0,
                          height: 40.0,
                          child: Icon(
                            Icons.location_on,
                            size: 40.0,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: 30.0,
                  left: 20.0,
                  child: FloatingActionButton(
                    onPressed: _getCurrentLocation,
                    child: Icon(Icons.my_location),
                    tooltip: 'Lokasi Saya',
                  ),
                ),
              ],
            ),
    );
  }
}

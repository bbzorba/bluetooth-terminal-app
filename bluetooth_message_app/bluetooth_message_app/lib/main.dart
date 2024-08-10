import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(BluetoothApp());

class BluetoothApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluetooth Communication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BluetoothHomePage(),
    );
  }
}

class BluetoothHomePage extends StatefulWidget {
  @override
  _BluetoothHomePageState createState() => _BluetoothHomePageState();
}

class _BluetoothHomePageState extends State<BluetoothHomePage> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    setState(() {
      isScanning = true;
      scanResults.clear();
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4)).then((_) {
      setState(() {
        isScanning = false;
      });
    });

    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    flutterBlue.isScanning.listen((isScanning) {
      setState(() {
        this.isScanning = isScanning;
      });
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    print('Connecting to device: ${device.name}');

    try {
      await device.connect();
      print('Connected to device: ${device.name}');
      setState(() {
        connectedDevice = device;
      });
    } catch (e) {
      print('Error connecting to device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Communication'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: scanForDevices,
          ),
        ],
      ),
      body: isScanning
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                ScanResult result = scanResults[index];
                BluetoothDevice device = result.device;
                return ListTile(
                  title: Text(
                      device.name.isEmpty ? 'Unknown Device' : device.name),
                  subtitle: Text(device.id.toString()),
                  onTap: () => connectToDevice(device),
                );
              },
            ),
    );
  }
}

import 'package:flutter_ble_lib/flutter_ble_lib.dart';
import './ScannedDevices.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'dart:convert';

class BTServices {
  static List<ScannedDevices> listOfConnectedDevices = [];
  static List<ScannedDevices> listOfDevices = [];
  PeripheralConnectionState state;
  bool _connected;

  String serviceUUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  String characteristicsUUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  List<String> uuid;
  Peripheral peripheral;
  BleManager _bleManager = BleManager();
  bool get connectedState => _connected;

  StreamController<List<ScannedDevices>> visibleDevicesController =
      StreamController.broadcast();

  StreamController<List<ScannedDevices>> connectedDevicesController =
      StreamController.broadcast();

  //Getters
  Stream<List<ScannedDevices>> get connectedDevices =>
      connectedDevicesController.stream;

  Stream<List<ScannedDevices>> get visibleDevices =>
      visibleDevicesController.stream;

  PermissionStatus _locationPermissionStatus = PermissionStatus.unknown;

  void _addScannedDevices(
      title, Peripheral peripheral, List<ScannedDevices> listOfDevices) {
    final addDevList = ScannedDevices(title: title, peripheral: peripheral);
    listOfDevices.add(addDevList);
    visibleDevicesController.add(listOfDevices);
  }

  void _addConnectedDevices(title, Peripheral peripheral,
      List<ScannedDevices> listOfConnectedDevices) {
    final addConnectedDev =
        ScannedDevices(title: title, peripheral: peripheral);
    listOfConnectedDevices.add(addConnectedDev);
    connectedDevicesController.add(listOfConnectedDevices);
  }

  //CREATE BLE MANAGER

  void init() {
    print("Starting void init");
    listOfDevices.clear();
    listOfConnectedDevices.clear();
    _checkPermissions()
        .catchError((e) => print("Permissions check err $e"))
        // .then((_) => _waitForBluetoothPoweredOn())
        .then((_) => scanPeripherals());
  }

  // LOCATION PERMISSION STATUS
  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      var permissionStatus = await PermissionHandler()
          .requestPermissions([PermissionGroup.location]);

      _locationPermissionStatus = permissionStatus[PermissionGroup.location];

      if (_locationPermissionStatus != PermissionStatus.granted) {
        return Future.error(
          Exception("LocationPermission not granted"),
        );
      }
    }
  }

  //INITIALIZE BLE
  //Create client and display the bluetooth state whether it is available or not
  Future<void> initializeBle() async {
    await _bleManager.createClient();
    // _bleManager.enableRadio();
    BluetoothState currentState = await _bleManager.bluetoothState();
    _bleManager.observeBluetoothState().listen((btState) {
      if (btState == BluetoothState.POWERED_OFF) {
        _bleManager.enableRadio();
        print("BT ON");
      }
      print(btState);
      //do your BT logic, open different screen, etc.
    });
  }

  StreamSubscription<ScanResult> _scanSubscription;

  //Scan Peripherals
  void scanPeripherals() {
    _scanSubscription = _bleManager.startPeripheralScan(uuids: [
      "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
    ]).listen((ScanResult scanResult) {
      if (scanResult.advertisementData.localName != null &&
          listOfDevices.isEmpty) {
        _addScannedDevices(
            scanResult.peripheral.name, scanResult.peripheral, listOfDevices);
      }
      if (listOfDevices.isNotEmpty) {
        _bleManager.stopPeripheralScan();
        print(listOfDevices[0]);
      }
      print("Scanned Peripheral ${scanResult.peripheral.name}");
      peripheral = scanResult.peripheral;
    });
  }

  Future<void> connectToPeripherals() async {
    peripheral
        .observeConnectionState(
            emitCurrentValue: true, completeOnDisconnect: true)
        .listen((connectionState) {
      state = connectionState;
      print(
          "Peripheral ${peripheral.identifier} connection state is $connectionState");
      // print(state);
    });
    await peripheral.connect();
    _connected = await peripheral.isConnected();
    if (_connected && listOfConnectedDevices.isEmpty) {
      _addConnectedDevices(peripheral.name, peripheral, listOfConnectedDevices);
      await peripheral
          .discoverAllServicesAndCharacteristics()
          .then((_) => peripheral.services())
          .then((services) {
        print("Printing services for ${peripheral.name}");
        services.forEach((service) => print("Found service ${service.uuid}"));
        return services.first;
      }).then((service) async {
        print("Printing Characteristics for service ${service.uuid}");
        List<Characteristic> characteristics = await service.characteristics();
        characteristics.forEach((characteristic) {
          print("${characteristic.uuid}");
        });
        print(
            "PRINTING CHARACTERISTICS FROM \nPERIPHERAL for the same service");
        return peripheral.characteristics(service.uuid);
      }).then((characteristics) => characteristics.forEach((characteristic) =>
              print("Found characteristic \n ${characteristic.uuid}")));
      // .then((_) => getInputCharacteristics());
      
    }
    if (state == PeripheralConnectionState.connected) {
      // ValueNotifier(connectionState)
      print("Device connected");
      
    }
  }

  void moveForward() {
    List<int> bytes = utf8.encode("1");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }

  void moveBackwards() {
    List<int> bytes = utf8.encode("-1");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }

  void turnLeft() {
    List<int> bytes = utf8.encode("3");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }

  void turnRight() {
    List<int> bytes = utf8.encode("4");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }

  void stopBackMotor() {
    List<int> bytes = utf8.encode("0");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }

  void stopFrontMotor() {
    List<int> bytes = utf8.encode("00");
    peripheral.writeCharacteristic(
      serviceUUID,
      characteristicsUUID,
      Uint8List.fromList(bytes),
      false,
    );
    print("characteristics written to CarZZ");
  }
}

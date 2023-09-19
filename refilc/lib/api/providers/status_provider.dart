import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

enum Status { network, maintenance, syncing }

class StatusProvider extends ChangeNotifier {
  final List<Status> _stack = [];
  double _progress = 0.0;
  ConnectivityResult _networkType = ConnectivityResult.none;
  ConnectivityResult get networkType => _networkType;

  StatusProvider() {
    _handleNetworkChanges();
    Connectivity().checkConnectivity().then((value) => _networkType = value);
  }

  Status? getStatus() => _stack.isNotEmpty ? _stack[0] : null;
  // Status progress from 0.0 to 1.0
  double get progress => _progress;

  void _handleNetworkChanges() {
    Connectivity().onConnectivityChanged.listen((event) {
      _networkType = event;
      if (event == ConnectivityResult.none) {
        if (!_stack.contains(Status.network)) {
          _stack.insert(0, Status.network);
          notifyListeners();
        }
      } else {
        if (_stack.contains(Status.network)) {
          _stack.remove(Status.network);
          notifyListeners();
        }
      }
    });
  }

  void triggerRequest(http.Response res) {
    if (res.headers.containsKey("x-maintenance-mode") || res.statusCode == 503) {
      if (!_stack.contains(Status.maintenance)) {
        _stack.insert(0, Status.maintenance);
        notifyListeners();
      }
    } else {
      if (_stack.contains(Status.maintenance)) {
        _stack.remove(Status.maintenance);
        notifyListeners();
      }
    }
  }

  void triggerSync({required int current, required int max}) {
    double prev = _progress;

    if (!_stack.contains(Status.syncing)) {
      _stack.add(Status.syncing);
      _progress = 0.0;
      notifyListeners();
    }

    if (max == 0) {
      _progress = 0.0;
    } else {
      _progress = current / max;
    }

    if (_progress == 1.0) {
      notifyListeners();
      // Wait for animation
      Future.delayed(const Duration(milliseconds: 250), () {
        _stack.remove(Status.syncing);
        notifyListeners();
      });
    } else if (progress != prev) {
      notifyListeners();
    }
  }
}

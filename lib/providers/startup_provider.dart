import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/startup.dart';

class StartupProvider with ChangeNotifier {
  List<Startup> _startups = [];
  bool _isLoading = false;
  String? _error;

  List<Startup> get startups => _startups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load startups from storage
  Future<void> loadStartups() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final startupsJson = prefs.getStringList('startups') ?? [];
      
      _startups = startupsJson
          .map((json) => Startup.fromJson(jsonDecode(json)))
          .toList();
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load startups: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  // Add new startup
  Future<bool> addStartup(Startup startup) async {
    _setLoading(true);
    try {
      _startups.add(startup);
      await _saveToStorage();
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to add startup: $e';
      debugPrint(_error);
      _setLoading(false);
      return false;
    }
  }

  // Remove startup
  Future<bool> removeStartup(String id) async {
    _setLoading(true);
    try {
      _startups.removeWhere((startup) => startup.id == id);
      await _saveToStorage();
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to remove startup: $e';
      debugPrint(_error);
      _setLoading(false);
      return false;
    }
  }

  // Update startup
  Future<bool> updateStartup(Startup updatedStartup) async {
    _setLoading(true);
    try {
      final index = _startups.indexWhere((startup) => startup.id == updatedStartup.id);
      if (index != -1) {
        _startups[index] = updatedStartup;
        await _saveToStorage();
        _error = null;
        _setLoading(false);
        return true;
      } else {
        _error = 'Startup not found';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = 'Failed to update startup: $e';
      debugPrint(_error);
      _setLoading(false);
      return false;
    }
  }

  // Get startup by id
  Startup? getStartupById(String id) {
    try {
      return _startups.firstWhere((startup) => startup.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get user submitted startups only
  List<Startup> get userSubmittedStartups {
    return _startups.where((startup) => startup.isUserSubmitted).toList();
  }

  // Clear all startups
  Future<bool> clearAllStartups() async {
    _setLoading(true);
    try {
      _startups.clear();
      await _saveToStorage();
      _error = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _error = 'Failed to clear startups: $e';
      debugPrint(_error);
      _setLoading(false);
      return false;
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final startupsJson = _startups
        .map((startup) => jsonEncode(startup.toJson()))
        .toList();
    await prefs.setStringList('startups', startupsJson);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await loadStartups();
  }
}
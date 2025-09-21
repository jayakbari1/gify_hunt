import 'package:gify/gify/resources.dart';

import '../models/gif_data_dm.dart';

class DummyGifData {
  static List<GifDataDm> _gifDataList = [];

  // Get all GIF data
  static List<GifDataDm> get allGifData => _gifDataList;

  // Initialize with dummy data
  static void initializeDummyData() {
    _gifDataList = [
      // Sample data for existing GIFs
      GifDataDm(
        id: 1,
        gifName: 'aa_ani.gif',
        businessName: 'AA Animations',
        websiteUrl: 'https://aa-animations.com',
        description: 'Creative animation studio',
        gifPath: SvgGifs.aaAni,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      GifDataDm(
        id: 2,
        gifName: 'amazon.gif',
        businessName: 'Amazon',
        websiteUrl: 'https://amazon.com',
        description: 'E-commerce giant',
        gifPath: SvgGifs.amazon,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      GifDataDm(
        id: 3,
        gifName: 'google.gif',
        businessName: 'Google',
        websiteUrl: 'https://google.com',
        description: 'Search engine and technology company',
        gifPath: SvgGifs.aaaclipbut1,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      GifDataDm(
        id: 4,
        gifName: 'apple.gif',
        businessName: 'Apple Inc.',
        websiteUrl: 'https://apple.com',
        description: 'Technology and consumer electronics',
        gifPath: SvgGifs.applelinks,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      GifDataDm(
        id: 5,
        gifName: 'microsoft.gif',
        businessName: 'Microsoft',
        websiteUrl: 'https://microsoft.com',
        description: 'Software and cloud computing',
        gifPath: SvgGifs.ab03,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  // Add new GIF data
  static void addGifData(GifDataDm gifData) {
    _gifDataList.add(gifData);
  }

  // Remove GIF data by ID
  static void removeGifData(int id) {
    _gifDataList.removeWhere((data) => data.id == id);
  }

  // Update GIF data
  static void updateGifData(GifDataDm updatedData) {
    final index = _gifDataList.indexWhere((data) => data.id == updatedData.id);
    if (index != -1) {
      _gifDataList[index] = updatedData;
    }
  }

  // Get GIF data by ID
  static GifDataDm? getGifDataById(int id) {
    try {
      return _gifDataList.firstWhere((data) => data.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get GIF data by path
  static GifDataDm? getGifDataByPath(String path) {
    try {
      return _gifDataList.firstWhere((data) => data.gifPath == path);
    } catch (e) {
      return null;
    }
  }

  // Get next available ID
  static int getNextId() {
    if (_gifDataList.isEmpty) return 1;
    return _gifDataList.map((data) => data.id).reduce((a, b) => a > b ? a : b) +
        1;
  }

  // Clear all data
  static void clearAll() {
    _gifDataList.clear();
  }

  // Get user submitted GIFs only
  static List<GifDataDm> get userSubmittedGifs {
    return _gifDataList.where((data) => data.isUserSubmitted).toList();
  }

  // Get pre-existing GIFs only
  static List<GifDataDm> get preExistingGifs {
    return _gifDataList.where((data) => !data.isUserSubmitted).toList();
  }
}

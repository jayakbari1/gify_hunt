import 'package:gify/gify/resources.dart';

import '../models/gif_data_dm.dart';

class DummyGifData {
  static List<GifDataDm> _gifDataList = [];

  // Get all GIF data
  static List<GifDataDm> get allGifData => _gifDataList;

  // Initialize with comprehensive dummy data for ALL SvgGifs
  static void initializeDummyData() {
    _gifDataList = [
      // AA Series
      GifDataDm(
        id: 1,
        gifName: 'aa_ani.gif',
        businessName: 'AA Animations',
        websiteUrl: 'https://aa-animations.com',
        description: 'Creative animation studio specializing in web graphics',
        gifPath: SvgGifs.aaAni,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
      ),
      GifDataDm(
        id: 2,
        gifName: 'aa_logo.gif',
        businessName: 'AA Logo Design',
        websiteUrl: 'https://aa-logo.com',
        description: 'Professional logo design services',
        gifPath: SvgGifs.aaLogo,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 364)),
      ),
      GifDataDm(
        id: 3,
        gifName: 'aaaclipbut1.gif',
        businessName: 'AAA Clip Studio',
        websiteUrl: 'https://aaaclip.com',
        description: 'Digital art and animation tools',
        gifPath: SvgGifs.aaaclipbut1,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 363)),
      ),
      GifDataDm(
        id: 4,
        gifName: 'aaextreme.gif',
        businessName: 'AA Extreme Sports',
        websiteUrl: 'https://aaextreme.com',
        description: 'Extreme sports equipment and gear',
        gifPath: SvgGifs.aaextreme,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 362)),
      ),

      // AB Series
      GifDataDm(
        id: 5,
        gifName: 'ab-white.gif',
        businessName: 'AB White Design',
        websiteUrl: 'https://abwhite.com',
        description: 'Minimalist design agency',
        gifPath: SvgGifs.abWhite,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 361)),
      ),
      GifDataDm(
        id: 6,
        gifName: 'ab-yr.gif',
        businessName: 'AB Year Round',
        websiteUrl: 'https://ab-yr.com',
        description: 'Year-round business solutions',
        gifPath: SvgGifs.abYr,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 360)),
      ),
      GifDataDm(
        id: 7,
        gifName: 'ab.gif',
        businessName: 'AB Corporation',
        websiteUrl: 'https://ab-corp.com',
        description: 'Global business corporation',
        gifPath: SvgGifs.ab,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 359)),
      ),
      GifDataDm(
        id: 8,
        gifName: 'ab03.gif',
        businessName: 'AB Tech 2003',
        websiteUrl: 'https://ab03.com',
        description: 'Legacy technology solutions',
        gifPath: SvgGifs.ab03,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 358)),
      ),

      // ABC Series
      GifDataDm(
        id: 9,
        gifName: 'abcdir-banner6.gif',
        businessName: 'ABC Directory',
        websiteUrl: 'https://abcdirectory.com',
        description: 'Online business directory service',
        gifPath: SvgGifs.abcdirBanner6,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 357)),
      ),
      GifDataDm(
        id: 10,
        gifName: 'abcgiant.gif',
        businessName: 'ABC Giant',
        websiteUrl: 'https://abcgiant.com',
        description: 'Large-scale retail solutions',
        gifPath: SvgGifs.abcgiant,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 356)),
      ),
      GifDataDm(
        id: 11,
        gifName: 'aboutg.gif',
        businessName: 'About Graphics',
        websiteUrl: 'https://aboutgraphics.com',
        description: 'Professional graphic design services',
        gifPath: SvgGifs.aboutg,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 355)),
      ),
      GifDataDm(
        id: 12,
        gifName: 'abrbus.gif',
        businessName: 'ABR Business Solutions',
        websiteUrl: 'https://abrbus.com',
        description: 'Business consulting and strategy',
        gifPath: SvgGifs.abrbus,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 354)),
      ),
      GifDataDm(
        id: 13,
        gifName: 'abrowser.gif',
        businessName: 'A-Browser Technology',
        websiteUrl: 'https://abrowser.com',
        description: 'Web browser development',
        gifPath: SvgGifs.abrowser,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 353)),
      ),
      GifDataDm(
        id: 14,
        gifName: 'absfree.gif',
        businessName: 'ABS Free Software',
        websiteUrl: 'https://absfree.com',
        description: 'Free and open source software',
        gifPath: SvgGifs.absfree,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 352)),
      ),
      GifDataDm(
        id: 15,
        gifName: 'absoft_logo.gif',
        businessName: 'Absoft Corporation',
        websiteUrl: 'https://absoft.com',
        description: 'Fortran compiler and development tools',
        gifPath: SvgGifs.absoftLogo,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 351)),
      ),
      GifDataDm(
        id: 16,
        gifName: 'absolute_ftp.gif',
        businessName: 'Absolute FTP',
        websiteUrl: 'https://absoluteftp.com',
        description: 'Professional FTP client software',
        gifPath: SvgGifs.absoluteFtp,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 350)),
      ),
      GifDataDm(
        id: 17,
        gifName: 'absolutely.gif',
        businessName: 'Absolutely Digital',
        websiteUrl: 'https://absolutely.com',
        description: 'Digital marketing and web solutions',
        gifPath: SvgGifs.absolutely,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 349)),
      ),

      // AC Series
      GifDataDm(
        id: 18,
        gifName: 'ac-button-frobert.gif',
        businessName: 'AC Frobert Design',
        websiteUrl: 'https://acfrobert.com',
        description: 'Custom web button solutions',
        gifPath: SvgGifs.acButtonFrobert,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 348)),
      ),
      GifDataDm(
        id: 19,
        gifName: 'acab.gif',
        businessName: 'ACAB Studios',
        websiteUrl: 'https://acabstudios.com',
        description: 'Independent media production',
        gifPath: SvgGifs.acab,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 347)),
      ),
      GifDataDm(
        id: 20,
        gifName: 'acapickels.gif',
        businessName: 'ACA Pickels',
        websiteUrl: 'https://acapickels.com',
        description: 'Gourmet pickle manufacturer',
        gifPath: SvgGifs.acapickels,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 346)),
      ),
      GifDataDm(
        id: 21,
        gifName: 'acaza.gif',
        businessName: 'Acaza Technologies',
        websiteUrl: 'https://acaza.com',
        description: 'Technology solutions provider',
        gifPath: SvgGifs.acaza,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 345)),
      ),
      GifDataDm(
        id: 22,
        gifName: 'accelerating.gif',
        businessName: 'Accelerating Business',
        websiteUrl: 'https://accelerating.com',
        description: 'Business acceleration and growth services',
        gifPath: SvgGifs.accelerating,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 344)),
      ),
      GifDataDm(
        id: 23,
        gifName: 'accursed-farms-alien-blink.gif',
        businessName: 'Accursed Farms',
        websiteUrl: 'https://accursedfarms.com',
        description: 'Gaming content creator and reviewer',
        gifPath: SvgGifs.accursedFarmsAlienBlink,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 343)),
      ),
      GifDataDm(
        id: 24,
        gifName: 'acdsee.gif',
        businessName: 'ACDSee',
        websiteUrl: 'https://acdsee.com',
        description: 'Photo management and editing software',
        gifPath: SvgGifs.acdsee,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 342)),
      ),
      GifDataDm(
        id: 25,
        gifName: 'aceftp.gif',
        businessName: 'AceFTP',
        websiteUrl: 'https://aceftp.com',
        description: 'Professional FTP client application',
        gifPath: SvgGifs.aceftp,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 341)),
      ),
      GifDataDm(
        id: 26,
        gifName: 'aceplay.gif',
        businessName: 'AcePlay Media',
        websiteUrl: 'https://aceplay.com',
        description: 'Media player and streaming software',
        gifPath: SvgGifs.aceplay,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 340)),
      ),
      GifDataDm(
        id: 27,
        gifName: 'achbus.gif',
        businessName: 'ACH Business Services',
        websiteUrl: 'https://achbus.com',
        description: 'Electronic payment processing',
        gifPath: SvgGifs.achbus,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 339)),
      ),

      // Acid Series - Creative & Music
      GifDataDm(
        id: 28,
        gifName: 'acid.gif',
        businessName: 'Acid Digital Arts',
        websiteUrl: 'https://aciddigital.com',
        description: 'Digital art and creative design',
        gifPath: SvgGifs.acid,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 338)),
      ),
      GifDataDm(
        id: 29,
        gifName: 'acid_prod.gif',
        businessName: 'Acid Productions',
        websiteUrl: 'https://acidprod.com',
        description: 'Music production and audio engineering',
        gifPath: SvgGifs.acidProd,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 337)),
      ),
      GifDataDm(
        id: 30,
        gifName: 'acidawards24.gif',
        businessName: 'Acid Awards 24',
        websiteUrl: 'https://acidawards.com',
        description: 'Annual digital art competition',
        gifPath: SvgGifs.acidawards24,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 336)),
      ),
      GifDataDm(
        id: 31,
        gifName: 'acidfonts.gif',
        businessName: 'Acid Fonts',
        websiteUrl: 'https://acidfonts.com',
        description: 'Typography and custom font design',
        gifPath: SvgGifs.acidfonts,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 335)),
      ),
      GifDataDm(
        id: 32,
        gifName: 'acidgloss.net.gif',
        businessName: 'Acid Gloss Network',
        websiteUrl: 'https://acidgloss.net',
        description: 'Web design community and resources',
        gifPath: SvgGifs.acidglossNet,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 334)),
      ),
      GifDataDm(
        id: 33,
        gifName: 'acidicdarkness.gif',
        businessName: 'Acidic Darkness',
        websiteUrl: 'https://acidicdarkness.com',
        description: 'Gothic and dark themed design studio',
        gifPath: SvgGifs.acidicdarkness,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 333)),
      ),
      GifDataDm(
        id: 34,
        gifName: 'acidlemon.gif',
        businessName: 'Acid Lemon Creative',
        websiteUrl: 'https://acidlemon.com',
        description: 'Fresh and vibrant design solutions',
        gifPath: SvgGifs.acidlemon,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 332)),
      ),

      // ACME & Corporate
      GifDataDm(
        id: 35,
        gifName: 'acmelogo.gif',
        businessName: 'ACME Corporation',
        websiteUrl: 'https://acme.com',
        description: 'Multi-industry manufacturing corporation',
        gifPath: SvgGifs.acmelogo,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 331)),
      ),

      // Active Series - Software & Technology
      GifDataDm(
        id: 36,
        gifName: 'activator.gif',
        businessName: 'Activator Software',
        websiteUrl: 'https://activator.com',
        description: 'Software licensing and activation',
        gifPath: SvgGifs.activator,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 330)),
      ),
      GifDataDm(
        id: 37,
        gifName: 'activewin.gif',
        businessName: 'ActiveWin Solutions',
        websiteUrl: 'https://activewin.com',
        description: 'Windows-based software development',
        gifPath: SvgGifs.activewin,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 329)),
      ),
      GifDataDm(
        id: 38,
        gifName: 'activeworlds.gif',
        businessName: 'ActiveWorlds',
        websiteUrl: 'https://activeworlds.com',
        description: '3D virtual world platform and community',
        gifPath: SvgGifs.activeworlds,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 328)),
      ),

      // Add Series - Web Services
      GifDataDm(
        id: 39,
        gifName: 'addchannel.gif',
        businessName: 'Add Channel Media',
        websiteUrl: 'https://addchannel.com',
        description: 'Streaming channel management platform',
        gifPath: SvgGifs.addchannel,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 327)),
      ),
      GifDataDm(
        id: 40,
        gifName: 'addesigner.gif',
        businessName: 'Ad Designer Studio',
        websiteUrl: 'https://addesigner.com',
        description: 'Professional advertisement design',
        gifPath: SvgGifs.addesigner,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 326)),
      ),
      GifDataDm(
        id: 41,
        gifName: 'addit1.gif',
        businessName: 'AddIt Web Services',
        websiteUrl: 'https://addit.com',
        description: 'Website enhancement and optimization',
        gifPath: SvgGifs.addit1,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 325)),
      ),
      GifDataDm(
        id: 42,
        gifName: 'addme.gif',
        businessName: 'AddMe Directory',
        websiteUrl: 'https://addme.com',
        description: 'Website submission and directory service',
        gifPath: SvgGifs.addme,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 324)),
      ),
      GifDataDm(
        id: 43,
        gifName: 'addmecom.gif',
        businessName: 'AddMe.com Services',
        websiteUrl: 'https://addme.com',
        description: 'Web directory and SEO services',
        gifPath: SvgGifs.addmecom,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 323)),
      ),
      GifDataDm(
        id: 44,
        gifName: 'addpro.gif',
        businessName: 'AddPro Solutions',
        websiteUrl: 'https://addpro.com',
        description: 'Professional web development services',
        gifPath: SvgGifs.addpro,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 322)),
      ),

      // Ad Series - Marketing & Advertising
      GifDataDm(
        id: 45,
        gifName: 'adecline.gif',
        businessName: 'Ad Decline Solutions',
        websiteUrl: 'https://adecline.com',
        description: 'Ad blocking and privacy protection',
        gifPath: SvgGifs.adecline,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 321)),
      ),
      GifDataDm(
        id: 46,
        gifName: 'adlogo.gif',
        businessName: 'Ad Logo Design Co.',
        websiteUrl: 'https://adlogo.com',
        description: 'Advertising and branding design',
        gifPath: SvgGifs.adlogo,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 320)),
      ),

      // Adobe Series - Creative Software
      GifDataDm(
        id: 47,
        gifName: 'adobe_asanim1.gif',
        businessName: 'Adobe Systems',
        websiteUrl: 'https://adobe.com',
        description: 'Creative software and digital solutions',
        gifPath: SvgGifs.adobeAsanim1,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 319)),
      ),
      GifDataDm(
        id: 48,
        gifName: 'adobe_atmosphere.gif',
        businessName: 'Adobe Atmosphere',
        websiteUrl: 'https://adobe.com',
        description: '3D web content creation tool',
        gifPath: SvgGifs.adobeAtmosphere,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 318)),
      ),
      GifDataDm(
        id: 49,
        gifName: 'adobe_authorware.gif',
        businessName: 'Adobe Authorware',
        websiteUrl: 'https://adobe.com',
        description: 'Interactive multimedia authoring',
        gifPath: SvgGifs.adobeAuthorware,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 317)),
      ),
      GifDataDm(
        id: 50,
        gifName: 'adobe_dreamweaver.gif',
        businessName: 'Adobe Dreamweaver',
        websiteUrl: 'https://adobe.com',
        description: 'Web development and design tool',
        gifPath: SvgGifs.adobeDreamweaver,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 316)),
      ),

      // Continue with comprehensive data for ALL remaining SvgGifs...
      // Adding more entries to ensure we have data for testing
      GifDataDm(
        id: 51,
        gifName: 'amazon.gif',
        businessName: 'Amazon',
        websiteUrl: 'https://amazon.com',
        description: 'Global e-commerce and cloud computing',
        gifPath: SvgGifs.amazon,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 315)),
      ),
      GifDataDm(
        id: 52,
        gifName: 'google.gif',
        businessName: 'Google',
        websiteUrl: 'https://google.com',
        description: 'Search engine and technology company',
        gifPath: SvgGifs.amazon,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 314)),
      ),
      GifDataDm(
        id: 53,
        gifName: 'microsoft.gif',
        businessName: 'Microsoft Corporation',
        websiteUrl: 'https://microsoft.com',
        description: 'Software and cloud computing giant',
        gifPath: SvgGifs.amazon,
        isUserSubmitted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 313)),
      ),

      // Add fallback entries for any remaining GIFs that might not be covered
      // This ensures hover data is available for testing
    ];

    // Auto-generate entries for any remaining SvgGifs that weren't manually added
    _ensureAllGifsHaveData();
  }

  // Helper method to ensure all SvgGifs have corresponding data
  static void _ensureAllGifsHaveData() {
    final existingPaths = _gifDataList.map((data) => data.gifPath).toSet();
    final allGifPaths = SvgGifs.gifPaths;

    int nextId = getNextId();

    for (int i = 0; i < allGifPaths.length; i++) {
      final gifPath = allGifPaths[i];

      if (!existingPaths.contains(gifPath)) {
        // Extract filename from path
        final filename = gifPath.split('/').last;
        // Create business name from filename
        String businessName = filename
            .replaceAll('.gif', '')
            .replaceAll('_', ' ')
            .replaceAll('-', ' ')
            .split(' ')
            .map(
              (word) =>
                  word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1),
            )
            .join(' ');

        if (businessName.isEmpty) businessName = 'Unknown Business';

        _gifDataList.add(
          GifDataDm(
            id: nextId++,
            gifName: filename,
            businessName: businessName,
            websiteUrl:
                'https://${filename.replaceAll('.gif', '').replaceAll('_', '').replaceAll('-', '')}.com',
            description: 'Digital services and solutions',
            gifPath: gifPath,
            isUserSubmitted: false,
            createdAt: DateTime.now().subtract(Duration(days: 300 - i)),
          ),
        );
      }
    }
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

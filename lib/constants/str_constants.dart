class StrConstants {
  static final StrConstants _instance = StrConstants._internal();

  factory StrConstants() => _instance;

  StrConstants._internal();

  // App Bar
  static const String startupSubmission = 'STARTUP SUBMISSION';

  // Header
  static const String systemUpload = 'SYSTEM UPLOAD';
  static const String startupDeployment = 'STARTUP DEPLOYMENT';
  static const String initializeStartup = 'Initialize your startup into the 88x31 matrix grid system';

  // Form Fields
  static const String startupIdentifier = 'STARTUP IDENTIFIER';
  static const String enterStartupName = 'Enter startup name...';
  static const String networkAddress = 'NETWORK ADDRESS';
  static const String websiteHint = 'https://your-startup.com';
  static const String contactEmail = 'CONTACT EMAIL';
  static const String enterContactEmail = 'Enter contact email...';
  static const String tagline = 'TAGLINE';
  static const String enterTagline = 'Enter startup tagline...';

  // GIF Upload
  static const String visualAssetUpload = 'VISUAL ASSET UPLOAD';
  static const String clickToUploadGif = 'CLICK TO UPLOAD GIF';
  static const String fileLoaded = 'FILE LOADED: ';
  static const String optimalPixels = 'Optimal: 88x31 pixels';

  // Submit Button
  static const String deployStartup = 'DEPLOY STARTUP';
  static const String deploying = 'DEPLOYING...';

  // Guidelines
  static const String systemRequirements = 'SYSTEM REQUIREMENTS';
  static const String gifDimensions = '• GIF dimensions: 88x31 pixels (optimal)';
  static const String fileSizeLimit = '• File size limit: 2MB maximum';
  static const String networkAccessible = '• Network address must be accessible';
  static const String contentReview = '• Content review process: 24-48 hours';
  static const String professionalContent = '• Professional content only';

  // Messages
  static const String pleaseUploadGif = 'Please upload a GIF file';
  static const String systemError = 'System error: ';
  static const String submissionSuccessful = 'Submission successful!';

  // Header Widget (if used)
  static const String joinStartupShowcase = 'Join Our Startup Showcase';
  static const String submitStartupDescription = 'Submit your startup to be featured in our 88x31 pixel showcase gallery';

  // My Submissions
  static const String mySubmissions = 'My Submissions';
  static const String noSubmissionsYet = 'No submissions yet.';
  static const String status = 'Status: ';

  // Dialog
  static const String error = 'Error';
  static const String ok = 'OK';

  // Main.dart dialog
  static const String taglineLabel = 'Tagline: ';
  static const String nameLabel = 'Name: ';
  static const String startupSpotlight = 'STARTUP SPOTLIGHT';
  static const String taglineFlash = 'TAGLINE FLASH';
  static const String visitSite = 'VISIT SITE';
  static const String cancel = 'CANCEL';
}

enum Environment { dev, prod }

class EnvironmentConfig {
  static Environment environment = Environment.dev;
  
  // Firestore collection names
  static String get submissionsCollection => environment == Environment.dev 
      ? 'dev_submissions' 
      : 'submissions';
  
  // Environment helper methods
  static void setEnvironment(Environment env) {
    environment = env;
  }
  
  static bool get isDevelopment => environment == Environment.dev;
  static bool get isProduction => environment == Environment.prod;
}
enum Environment { dev, prod }

class EnvironmentConfig {
  static Environment environment = Environment.dev;
  static String get submissionsCollection => 'dev_submissions';
  static String get approvedCollection => 'dev_approved_startups';
}
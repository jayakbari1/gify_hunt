# Firebase Setup Guide

This guide explains how to set up Firebase for both development and production environments.

## Prerequisites

1. Firebase CLI installed: `npm install -g firebase-tools`
2. Two Firebase projects:
   - Development project (e.g., `gify-dev`)
   - Production project (e.g., `gify-prod`)

## Step 1: Create Production Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name it `gify-prod` (or your preferred production project name)
4. Follow the setup wizard
5. Enable Firestore Database
6. Enable Firebase Hosting

## Step 2: Update .firebaserc

Edit the `.firebaserc` file and replace the project IDs with your actual Firebase project IDs:

- Replace `gify-dev` with your development project ID
- Replace `gify-prod` with your production project ID

## Step 3: Configure Firebase Hosting Targets

Run the following commands to configure hosting targets:

```bash
# Login to Firebase
firebase login

# For development project
firebase use gify-dev
firebase target:apply hosting dev gify-dev

# For production project
firebase use gify-prod
firebase target:apply hosting prod gify-prod
```

This will update the `.firebaserc` file with the correct hosting site mappings.

## Step 4: Get Firebase Configuration

For each project (dev and prod), you need to get the Firebase configuration:

1. Go to Firebase Console > Project Settings
2. Scroll down to "Your apps"
3. Click on the Web app (or create one if it doesn't exist)
4. Copy the configuration values

## Step 5: Update Production Firebase Configuration

### Update Dart Firebase Options

Edit `lib/config/firebase_options_prod.dart` and replace the placeholder values:

- `YOUR_PROD_API_KEY` → Your production API key
- `YOUR_PROD_APP_ID` → Your production App ID
- `YOUR_PROD_MESSAGING_SENDER_ID` → Your production Messaging Sender ID
- `YOUR_PROD_MEASUREMENT_ID` → Your production Measurement ID (for web)
- Update `projectId` to match your production project ID
- Update `authDomain` to match your production auth domain
- Update `storageBucket` to match your production storage bucket

### Update Web Firebase Configuration

Edit `web/index.html` and update the `prod` configuration object in the `firebaseConfigs` object with your production Firebase credentials:

```javascript
prod: {
  apiKey: "YOUR_PROD_API_KEY",
  authDomain: "gify-prod.firebaseapp.com",
  databaseURL: "https://gify-prod-default-rtdb.firebaseio.com",
  projectId: "gify-prod",
  storageBucket: "gify-prod.appspot.com",
  messagingSenderId: "YOUR_PROD_MESSAGING_SENDER_ID",
  appId: "YOUR_PROD_APP_ID",
  measurementId: "YOUR_PROD_MEASUREMENT_ID"
}
```

Also update the hostname detection logic in the `getEnvironment()` function to match your actual production domain.

## Step 6: Configure GitHub Secrets

Go to your GitHub repository > Settings > Secrets and variables > Actions, and add the following secrets:

1. **FIREBASE_TOKEN**: 
   - Generate by running: `firebase login:ci`
   - Copy the token and add it as a secret

2. **FIREBASE_DEV_PROJECT_ID**: 
   - Your development Firebase project ID (e.g., `gify-dev`)

3. **FIREBASE_PROD_PROJECT_ID**: 
   - Your production Firebase project ID (e.g., `gify-prod`)

## Step 7: Verify Setup

1. Push to `develop` branch → Should deploy to dev Firebase project
2. Push to `main` branch → Should deploy to prod Firebase project

## Manual Deployment (Optional)

If you need to deploy manually:

```bash
# Deploy to dev
firebase use gify-dev
firebase deploy --only hosting:dev

# Deploy to prod
firebase use gify-prod
firebase deploy --only hosting:prod
```

## Troubleshooting

### Issue: "Target not found"
Solution: Make sure you've run `firebase target:apply hosting` for both projects.

### Issue: "Project not found"
Solution: Verify your project IDs in GitHub secrets match your Firebase project IDs.

### Issue: "Authentication failed"
Solution: Regenerate your Firebase token using `firebase login:ci` and update the secret.


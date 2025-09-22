import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/startup_provider.dart';

class MySubmissionsScreen extends StatelessWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Submissions')),
      body: Consumer<StartupProvider>(
        builder: (context, provider, child) {
          final submissions = provider.userSubmissions;
          if (submissions.isEmpty)
            return const Center(child: Text('No submissions yet.'));

          return ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final startup = submissions[index];
              return ListTile(
                title: Text(startup.name),
                subtitle: Text('Status: ${startup.status}'),
                trailing: startup.notificationMessage != null
                    ? Text(
                        startup.notificationMessage!,
                        style: const TextStyle(color: Colors.green),
                      )
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}

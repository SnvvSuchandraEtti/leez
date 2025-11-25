import 'package:flutter/material.dart';

class Gethelp extends StatefulWidget {
  const Gethelp({super.key});

  @override
  State<Gethelp> createState() => _GethelpState();
}

class _GethelpState extends State<Gethelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us:'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Reach out via Email"),
            leading: const Icon(Icons.email),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen(title: 'Email Support')),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("LinkedIn"),
            leading: const Icon(Icons.link),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen(title: 'LinkedIn Profile')),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Contact Number"),
            leading: const Icon(Icons.phone),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BlankScreen(title: 'Phone Contact')),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

// Placeholder blank screen
class BlankScreen extends StatelessWidget {
  final String title;

  const BlankScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('Coming Soon...')),
    );
  }
}

import 'package:fliq/providers/auth_provider.dart';
import 'package:fliq/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  final List<Map<String, dynamic>> contacts = const [
    {
      'name': 'Christina',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Patricia',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'name': 'Celestine',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'Celestine',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
    {
      'name': 'Elizabeth',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
  ];

  final List<Map<String, dynamic>> chats = const [
    {
      'name': 'Regina Bearden',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg',
      'time': '10:00 AM',
    },
    {
      'name': 'Rhonda Rivera',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg',
      'time': '10:00 AM',
    },
    {
      'name': 'Mary Gratton',
      'image': 'https://randomuser.me/api/portraits/women/8.jpg',
      'time': '10:00 AM',
    },
    {
      'name': 'Annie Medved',
      'image': 'https://randomuser.me/api/portraits/men/9.jpg',
      'time': '10:00 AM',
    },
    {
      'name': 'Regina Bearden',
      'image': 'https://randomuser.me/api/portraits/women/10.jpg',
      'time': '10:00 AM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: user != null
            ? Text('${user.name}\'s Messages')
            : const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //color: Colors.red,
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            contacts[index]['image']!,
                          ),
                          //backgroundImage: AssetImage(contacts[index]['image']!),
                        ),
                        const SizedBox(height: 5),
                        Text(contacts[index]['name']!),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.mic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(chats[index]['image']!),
                    ),
                    title: Text(chats[index]['name']!),
                    subtitle: Text('Last message here...'),
                    trailing: Text(chats[index]['time']!),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatName: chats[index]['name']!,
                            chatImage: chats[index]['image']!,
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
                itemCount: chats.length,
              ),
              // child: ListView.builder(
              //   itemCount: chats.length,
              //   shrinkWrap: true,
              //   physics: const BouncingScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //       leading: CircleAvatar(
              //         radius: 30,
              //         backgroundImage: AssetImage(chats[index]['image']!),
              //       ),
              //       title: Text(chats[index]['name']!),
              //       trailing: Text(chats[index]['time']!),
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => ChatScreen(
              //               chatName: chats[index]['name']!,
              //               chatImage: chats[index]['image']!,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

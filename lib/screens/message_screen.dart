


import 'package:fliq/providers/auth_provider.dart';
import 'package:fliq/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final List<Map<String, dynamic>> contacts = const [
    {'name': 'Christina', 'image': 'https://randomuser.me/api/portraits/men/1.jpg'},
    {'name': 'Patricia', 'image': 'https://randomuser.me/api/portraits/women/2.jpg'},
    {'name': 'Celestine', 'image': 'https://randomuser.me/api/portraits/men/3.jpg'},
    {'name': 'Celestine', 'image': 'https://randomuser.me/api/portraits/women/4.jpg'},
    {'name': 'Elizabeth', 'image': 'https://randomuser.me/api/portraits/men/5.jpg'},
  ];

  final List<Map<String, dynamic>> allChats = const [
    {'name': 'Regina Bearden', 'image': 'https://randomuser.me/api/portraits/women/6.jpg', 'time': '10:00 AM'},
    {'name': 'Rhonda Rivera', 'image': 'https://randomuser.me/api/portraits/men/7.jpg', 'time': '10:00 AM'},
    {'name': 'Mary Gratton', 'image': 'https://randomuser.me/api/portraits/women/8.jpg', 'time': '10:00 AM'},
    {'name': 'Annie Medved', 'image': 'https://randomuser.me/api/portraits/men/9.jpg', 'time': '10:00 AM'},
    {'name': 'Regina Bearden', 'image': 'https://randomuser.me/api/portraits/women/10.jpg', 'time': '10:00 AM'},
  ];

  late List<Map<String, dynamic>> filteredChats;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredChats = List.from(allChats);
    _searchController.addListener(_filterChats);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredChats = List.from(allChats);
        _isSearching = false;
      } else {
        filteredChats = allChats.where((chat) {
          return chat['name']!.toLowerCase().contains(query);
        }).toList();
        _isSearching = true;
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredChats = List.from(allChats);
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: user != null
            ? Text('${user.name}\'s Messages')
            : const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status contacts row
            SizedBox(
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
                          backgroundImage: NetworkImage(contacts[index]['image']!),
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
            
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search chats',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : const Icon(Icons.mic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Chat list header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chats',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (filteredChats.isEmpty)
                  Text(
                    'No matches',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            // Chat list
            Expanded(
              child: filteredChats.isEmpty
                  ? const Center(
                      child: Text('No conversations found'),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(chat['image']!),
                          ),
                          title: Text(chat['name']!),
                          subtitle: Text('Last message here...'),
                          trailing: Text(chat['time']!),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  chatName: chat['name']!,
                                  chatImage: chat['image']!,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(height: 15),
                      itemCount: filteredChats.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

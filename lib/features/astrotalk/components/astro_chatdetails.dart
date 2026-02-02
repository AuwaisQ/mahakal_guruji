import 'package:flutter/material.dart';

class ChatDetailsPage extends StatefulWidget {
  const ChatDetailsPage({super.key});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final List<ChatContact> chatContacts = [
    ChatContact(
      name: 'John Doe',
      lastMessage: 'Hey, how are you?',
      time: '10:00 AM',
      profilePictureUrl:
          'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    ),
    ChatContact(
      name: 'Jane Smith',
      lastMessage: 'See you later!',
      time: 'Yesterday',
      profilePictureUrl:
          'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    ),
    ChatContact(
      name: 'Bob Johnson',
      lastMessage: 'Okay, sounds good.',
      time: '2 days ago',
      profilePictureUrl:
          'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chatContacts.length,
        itemBuilder: (context, index) {
          return ChatTile(chatContact: chatContacts[index]);
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chatContact});

  final ChatContact chatContact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: Colors.grey.shade300,
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(chatContact.profilePictureUrl),
          ),
          title: Text(chatContact.name),
          subtitle: Text(chatContact.lastMessage),
          trailing: Text(chatContact.time),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChatScreenView(),
            //   ),
            // );
          },
        ),
      ],
    );
  }
}

class ChatContact {
  final String name;
  final String lastMessage;
  final String time;
  final String profilePictureUrl;

  ChatContact({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.profilePictureUrl,
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/chat/chat_screen.dart';
import 'package:easyshop/views/screens/fetchChat/detail_chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FetchChat extends StatefulWidget {
  const FetchChat({super.key});

  @override
  State<FetchChat> createState() => _FetchChatState();
}

class _FetchChatState extends State<FetchChat> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  markAsRead(String vendorId, String buyerId, String productId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .where('vendorId', isEqualTo: vendorId)
        .where('buyerId', isEqualTo: buyerId)
        .where('productId', isEqualTo: productId)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'isReadBuyer': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
        .collection('chats')
        .where('buyerId', isEqualTo: auth.currentUser!.uid)
        .snapshots();
    TextStyle appbarStyle = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    TextStyle messageStyle = GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    );
    TextStyle subtitleStyle = GoogleFonts.roboto(
      fontSize: 14,
      color: Colors.grey[600],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat', style: appbarStyle),
        backgroundColor: const Color(0xFF0C2D57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.grey[200],
        child: StreamBuilder<QuerySnapshot>(
          stream: chatStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            // if empty
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Messages Found',
                    style: TextStyle(color: Colors.black)),
              );
            }

            // Process messages to get the latest one for each vendor
            Map<String, Map<String, dynamic>> latestMessages = {};
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              String vendorId = data['vendorId'].toString();
              String senderId = data['senderId'].toString();
              Timestamp timestamp = data['chatTimeStamp'] as Timestamp;

              // Ensure we are only considering vendor messages
              if (senderId != auth.currentUser!.uid) {
                if (!latestMessages.containsKey(vendorId) ||
                    timestamp.compareTo(
                            latestMessages[vendorId]!['chatTimeStamp']) >
                        0) {
                  latestMessages[vendorId] = data;
                }
              }
            }

            return ListView.builder(
              itemCount: latestMessages.length,
              itemBuilder: (context, index) {
                String vendorId = latestMessages.keys.elementAt(index);
                Map<String, dynamic> data = latestMessages[vendorId]!;

                return GestureDetector(
                  onTap: () async {
                    // Mark as read
                    await markAsRead(data['vendorId'], auth.currentUser!.uid,
                        data['productId']);

                    // Navigate to chat detail screen
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatDetailScreen(
                            vendorId: data['vendorId'],
                            buyerId: auth.currentUser!.uid,
                            productId: data['productId'],
                            data: data);
                      },
                    ));
                  },
                  child: Card(
                    color: (data['isReadBuyer'] ?? false)
                        ? Colors.grey
                        : Colors.white,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(data['storeImage']),
                      ),
                      title: Text(
                        data['message'],
                        style: messageStyle,
                      ),
                      subtitle: Text(data['vendorName'], style: subtitleStyle),
                      trailing:
                          Icon(Icons.chevron_right, color: Colors.grey[600]),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

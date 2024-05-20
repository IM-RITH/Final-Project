import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String vendorId;
  final String buyerId;
  final String productId;
  final String productName;

  const ChatScreen({
    super.key,
    required this.vendorId,
    required this.buyerId,
    required this.productId,
    required this.productName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late Stream<QuerySnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    _chatStream = db
        .collection('chats')
        .where('buyerId', isEqualTo: widget.buyerId)
        .where('vendorId', isEqualTo: widget.vendorId)
        .where('productId', isEqualTo: widget.productId)
        .orderBy('chatTimeStamp', descending: false)
        .snapshots();
  }

  Future<void> _sendMessage() async {
    try {
      DocumentSnapshot vendorDoc =
          await db.collection('vendors').doc(widget.vendorId).get();
      DocumentSnapshot customerDoc =
          await db.collection('buyers').doc(widget.buyerId).get();

      String message = _messageController.text.trim();

      if (message.isNotEmpty) {
        await db.collection('chats').add({
          'vendorId': widget.vendorId,
          'buyerId': widget.buyerId,
          'productId': widget.productId,
          'productName': widget.productName,
          'customerName':
              (customerDoc.data() as Map<String, dynamic>)['username'] ??
                  'Unknown',
          'vendorName':
              (vendorDoc.data() as Map<String, dynamic>)['storeName'] ??
                  'Unknown',
          'storeImage':
              (vendorDoc.data() as Map<String, dynamic>)['storeImage'] ?? '',
          'customerImage':
              (customerDoc.data() as Map<String, dynamic>)['profileImage'] ??
                  '',
          'message': message,
          'senderId': FirebaseAuth.instance.currentUser!.uid,
          'chatTimeStamp': DateTime.now(),
        });
        _messageController.clear();
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Chat > ${widget.productName}',
          style: GoogleFonts.roboto(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _chatStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print('StreamBuilder error: ${snapshot.error}');
                  return Center(
                    child: Text(
                      'Something went wrong: ${snapshot.error}',
                      style: GoogleFonts.roboto(color: Colors.red),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    bool isSender = data['senderId'] ==
                        FirebaseAuth.instance.currentUser!.uid;
                    DateTime chatTime =
                        (data['chatTimeStamp'] as Timestamp).toDate();
                    String formattedTime =
                        DateFormat('hh:mm a').format(chatTime);
                    String customerImage = data['storeImage'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: isSender
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isSender && customerImage.isNotEmpty)
                            CircleAvatar(
                              backgroundImage: NetworkImage(customerImage),
                              radius: 20.0,
                            ),
                          if (!isSender && customerImage.isNotEmpty)
                            const SizedBox(width: 10.0),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: isSender
                                  ? const Color(0xFF0C2D57)
                                  : const Color(0xFF0C2D57),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(15.0),
                                topRight: const Radius.circular(15.0),
                                bottomLeft: isSender
                                    ? const Radius.circular(15.0)
                                    : Radius.zero,
                                bottomRight: isSender
                                    ? Radius.zero
                                    : const Radius.circular(15.0),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['message'],
                                  style: GoogleFonts.roboto(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Text(
                                    //   data['customerName'] ?? 'Unknown',
                                    //   style: GoogleFonts.roboto(
                                    //     fontSize: 12,
                                    //     color: Colors.grey[600],
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                    const SizedBox(width: 5),
                                    Text(
                                      formattedTime,
                                      style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Write a message...',
                      hintStyle: GoogleFonts.roboto(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF153167),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

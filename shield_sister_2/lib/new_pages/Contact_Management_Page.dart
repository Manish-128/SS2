
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shield_sister_2/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Contact {
  String name;
  String phone;

  Contact(this.name, this.phone);

  Map<String, String> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class ContactManagementPage extends StatefulWidget {
  const ContactManagementPage({Key? key}) : super(key: key);

  @override
  ContactManagementPageState createState() => ContactManagementPageState();
}

class ContactManagementPageState extends State<ContactManagementPage> {
  String userId = "";
  List<Contact> contactList = [];
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? "";
    });
    print("User ID (hex string) is: $userId");
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() => _isLoading = true);
    try {
      final db = await mongo.Db.create(
        "mongodb+srv://gaznavisheikh01:gazi12345@cluster0.ms5wq.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0",
      );
      await db.open();
      final collection = db.collection("contacts");

      final userObjectId = mongo.ObjectId.parse(userId);
      final contacts = await collection.find(mongo.where.eq('userId', userObjectId)).toList();
      await db.close();

      setState(() {
        contactList.clear();
        for (var doc in contacts) {
          contactList.add(Contact(doc['name'], doc['phone']));
        }
      });
    } catch (e) {
      print("Error fetching contacts: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching contacts: $e", style: GoogleFonts.poppins()),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool> _sendContactToBackend(String userId, Contact contact) async {
    setState(() => _isLoading = true);
    final result = await authService.SaveContact(userId, contact);
    setState(() => _isLoading = false);
    return result['message'] == "Contacts saved successfully!";
  }

  void _addContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    if (!phone.startsWith('+91')) {
      phone = '+91 ' + phone;
    }

    if (name.isNotEmpty && phone.isNotEmpty) {
      Contact newContact = Contact(name, phone);
      bool success = await _sendContactToBackend(userId, newContact);
      if (success) {
        setState(() {
          contactList.add(newContact);
        });
        _nameController.clear();
        _phoneController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Contact successfully added", style: GoogleFonts.poppins()),
            backgroundColor: Colors.grey.shade800,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add contact", style: GoogleFonts.poppins()),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _deleteContact(int index) {
    setState(() {
      contactList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Contact deleted", style: GoogleFonts.poppins()),
        backgroundColor: Colors.grey.shade800,
      ),
    );
  }

  void _editContact(int index) {
    _nameController.text = contactList[index].name;
    _phoneController.text = contactList[index].phone.replaceFirst('+91 ', '');
    setState(() {
      contactList.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Decorative background elements
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -80,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ),
              ),

              // Main content
              CustomScrollView(
                slivers: [
                  // Custom AppBar-like header
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: true,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Manage Contacts",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              shadows: [
                                Shadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: const Offset(2, 2),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.black),
                            onPressed: _fetchContacts,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Contact form and list
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Contact Name Input
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Contact Name",
                            labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        const SizedBox(height: 16),

                        // Phone Number Input
                        TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: GoogleFonts.poppins(color: Colors.grey.shade700),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                        const SizedBox(height: 24),

                        // Save Contact Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _addContact,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 8,
                          ),
                          child: Text(
                            "Save Contact",
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Contacts List
                        contactList.isEmpty
                            ? Center(
                          child: Text(
                            "No contacts found",
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey.shade700),
                          ),
                        )
                            : Column(
                          children: contactList.map((contact) {
                            int index = contactList.indexOf(contact);
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Text(
                                    contact.name[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  contact.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  contact.phone,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      _editContact(index);
                                    } else if (value == 'Delete') {
                                      _deleteContact(index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'Edit',
                                      child: Text('Edit', style: GoogleFonts.poppins()),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'Delete',
                                      child: Text('Delete', style: GoogleFonts.poppins()),
                                    ),
                                  ],
                                  icon: const Icon(Icons.more_vert, color: Colors.black),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 50), // Extra padding at the bottom
                      ]),
                    ),
                  ),
                ],
              ),

              // Loading indicator
              if (_isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
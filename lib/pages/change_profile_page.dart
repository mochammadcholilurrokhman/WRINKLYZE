import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String? selectedGender;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _setDefaultValues();
  }

  Future<void> _setDefaultValues() async {
    User? user = _auth.currentUser;
    setState(() {
      usernameController.text = user?.displayName ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    final double textFieldWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF052135),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey[700],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Add functionality to change picture
                  },
                  child: const Text(
                    'Change Picture',
                    style: TextStyle(
                      color: Color(0xFF1E88E5),
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: usernameController,
                  labelText: 'Username',
                  width: textFieldWidth,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: dobController,
                  labelText: 'Date of Birth',
                  width: textFieldWidth,
                  keyboardType: TextInputType.datetime,
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                const SizedBox(height: 20),
                _buildDropdownField(
                  width: textFieldWidth,
                  labelText: 'Gender',
                  items: ['Male', 'Female', 'Other'],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  value: selectedGender,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveProfileChanges,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(textFieldWidth, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: const Color(0xFF052135),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required double width,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0xFF797979),
            ),
            border: InputBorder.none,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required double width,
    required String labelText,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? value,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              color: Color(0xFF797979),
            ),
            border: InputBorder.none,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    String newUsername = usernameController.text;
    User? user = _auth.currentUser;

    if (user != null) {
      await user.updateDisplayName(newUsername);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2)),
      );
    }
  }
}

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  String gender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0), // Tinggi AppBar
        child: Container(
          width: 360,
          height: 158,
          color: const Color(0xFF7995A4), // Warna latar belakang AppBar
          child: Stack(
            clipBehavior: Clip.none, // Allow overflow outside the Stack
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    bottom:
                        20.0), // Adjust the bottom padding to move the text upwards
                child: Center(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 4.0, // Adjust the left position as needed
                top: 43.0, // Adjust the top position as needed
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // Logic to handle back button press
                  },
                ),
              ),
              Positioned(
                bottom:
                    -60, // Mengatur posisi untuk setengah Image di bawah AppBar
                left: MediaQuery.of(context).size.width / 2 -
                    50, // Agar berada di tengah layar
                child: const ClipOval(
                  child: Image(
                    width: 100, // Set the width of the image
                    height: 100, // Set the height of the image
                    image: AssetImage(
                        'assets/logo.png'), // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                // Logic to change profile picture
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit, // Choose an appropriate icon
                    color: Color(0xFF797979),
                    size: 20,
                  ),
                  SizedBox(
                      width: 3), // Add some space between the icon and the text
                  Text(
                    'Change Picture',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400, // Regular weight
                      fontSize: 16,
                      color: Color(0xFF797979),
                      decoration: TextDecoration.underline, // Add underline
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 350,
              height: 60,
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Color(0xFF797979),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0, // Dark grey border when focused
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 350,
              height: 60,
              child: TextField(
                controller: dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Color(0xFF797979),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0, // Dark grey border when focused
                    ),
                  ),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dobController.text =
                          '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                    });
                  }
                },
                readOnly: true,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 350,
              height: 60,
              child: DropdownButtonFormField<String>(
                value: gender,
                items: <String>['Male', 'Female', 'Other']
                    .map((String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: Color(0xFF797979),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2.0, // Dark grey border when focused
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 160),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(350, 60),
                side: const BorderSide(color: Colors.grey),
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
    );
  }
}

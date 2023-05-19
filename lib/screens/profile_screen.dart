import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/profile_home.dart';
import '../widgets/button_style.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late String _uid;
  File? _imageFile;
  late String _imageUrl;
  bool _isImageLoading = false;
  late UniqueKey _imageKey;

  Future<void> _loadUserProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _imageKey = UniqueKey();
      _imageUrl = '';
      //_imageKey = Key(_imageUrl);
      _uid = sharedPreferences.getString('uid')!;
    });
    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userSnapshot.exists) {
      final userData = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = userData['name'];
        _professionController.text = userData['profession'];
        _cityController.text = userData['city'];
        _addressController.text = userData['address'];
        _genderController.text = userData['gender'];
        _phoneNumberController.text = userData['phoneNumber'];
        _emailController.text = userData['email'];
      });
    }
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_pictures/$_uid.jpg');
    _imageUrl = await storageRef.getDownloadURL();
    setState(() {
      _imageUrl = _imageUrl;
      _imageKey = UniqueKey();
    });
  }

  Future<void> _saveUserProfile() async {
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_pictures/$_uid.jpg');
    _imageUrl = await storageRef.getDownloadURL();

    final userRef = FirebaseFirestore.instance.collection('users').doc(_uid);
    await userRef.update({
      'email': _emailController.text,
      'name': _nameController.text,
      'profession': _professionController.text,
      'city': _cityController.text,
      'address': _addressController.text,
      'gender': _genderController.text,
      'phoneNumber': _phoneNumberController.text,
    }).then((value) async {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User profile saved successfully!'),
        ),
      );
      setState(() async {
        // Retrieve the updated profile image URL from Firebase Storage
        final storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$_uid.jpg');
        _imageUrl = await storageRef.getDownloadURL();
      }); // Trigger a state update to refresh the UI with the updated image
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save user profile: $error'),
        ),
      );
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage =
        await ImagePicker().pickImage(source: source, imageQuality: 80);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _isImageLoading = true;
        _imageKey = UniqueKey(); // Assign a new UniqueKey
      });


      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$_uid.jpg');
      final uploadTask = storageRef.putFile(_imageFile!);
      await uploadTask.whenComplete(() => null);

      // Retrieve the updated profile image URL from Firebase Storage
      _imageUrl = await storageRef.getDownloadURL();

      setState(() {
        _isImageLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile image uploaded successfully!'),
        ),
      );
    }
  }

  Future<void> _changeInformation() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _professionController,
                  decoration: const InputDecoration(labelText: 'Profession'),
                ),
                TextField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _genderController,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveUserProfile();
                Navigator.of(context).pop();
              },
              style: buttonStyle,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _genderController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut();
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.setBool('isLoggedIn', false);
              Navigator.pushReplacementNamed(context, 'login_screen');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Column(
            children: [
              // Center(
              //   child: CircleAvatar(
              //     radius: 80,
              //     child: ClipOval(
              //       child: CachedNetworkImage(
              //         imageUrl: _imageUrl,
              //         placeholder: (context, url) =>
              //             CircularProgressIndicator(),
              //         errorWidget: (context, url, error) => Icon(Icons.error),
              //       ),
              //     ),
              //   ),
              // ),
              if (_isImageLoading)
                const CircularProgressIndicator()
              else
                GestureDetector(
                  onTap: () => _pickImage(ImageSource.gallery),
                  key: _imageKey, // Use _imageKey as the key for the GestureDetector
                  child: CircleAvatar(
                    radius: screenWidth * 0.15,
                    backgroundImage: (_imageFile != null)
                        ? FileImage(_imageFile!) as ImageProvider
                        : CachedNetworkImageProvider(_imageUrl.trim()),
                  ),
                ),
              SizedBox(height: screenHeight * 0.02),
              //_buildProfileInfo(),
              Column(
                children: [
                  SizedBox(height: 20.h),
                  ProfileMenu(
                    text1: "Name:",
                    text2: _nameController.text,
                    icon: const Icon(Icons.drive_file_rename_outline),
                  ),
                  ProfileMenu(
                    text1: "Email:",
                    text2: _emailController.text,
                    icon: const Icon(Icons.mail_outline_rounded),
                  ),
                  ProfileMenu(
                    text1: "Phone No:",
                    text2: _phoneNumberController.text,
                    icon: const Icon(Icons.phone),
                  ),
                  ProfileMenu(
                    text1: "Address:",
                    text2: _addressController.text,
                    icon: const Icon(Icons.location_pin),
                  ),
                  ProfileMenu(
                    text1: "Profession:",
                    text2: _professionController.text,
                    icon: const Icon(Icons.person_outline_outlined),
                  ),
                  ProfileMenu(
                    text1: "Gender:",
                    text2: _genderController.text,
                    icon: const Icon(Icons.female),
                  ),
                  ProfileMenu(
                    text1: "City:",
                    text2: _cityController.text,
                    icon: const Icon(Icons.location_city_outlined),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () => _changeInformation(),
                style: buttonStyle,
                child: Text(
                  "Edit Information",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

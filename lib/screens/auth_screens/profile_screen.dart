import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dopamind/auth/auth_service.dart';
import 'package:dopamind/services/photo_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final AuthService authService = AuthService();
  final PhotoService photoService = PhotoService();
  
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  Stream<DocumentSnapshot>? _userStream;

  @override
  void initState() {
    super.initState();
    final user = widget.authService.currentUser;
    if (user != null) {
      // Stream reads from local cache instantly on reload before hitting the server
      _userStream = FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();
    }
  }

  Future<void> _handleLogout() async {
    setState(() => _isLoading = true);
    await widget.authService.signOut();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showEditNameDialog(String currentName) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Edit Username", style: TextStyle(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: "New Username",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                setState(() => _isLoading = true);
                Navigator.pop(context);
                await widget.authService.updateUsername(username: newName);
                if (mounted) setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final passwordController = TextEditingController();
    final user = widget.authService.currentUser;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Account?", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "This action is permanent and cannot be undone. All your custom mind maps, profile data, and settings will be wiped.",
              style: TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final password = passwordController.text.trim();
              final email = user?.email;
              if (password.isEmpty || email == null) return;

              Navigator.pop(context);
              setState(() => _isLoading = true);

              try {
                await widget.authService.deleteAccount(email: email, password: password);
                if (!context.mounted) return;
                Navigator.of(context).popUntil((route) => route.isFirst);
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: ${e.toString()}")),
                );
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Delete Permanently", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPhotoSourceBottomSheet() {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Wrap(
            children: [
              const Center(
                child: Text("Update Profile Picture", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: "Gallery",
                    onTap: () => _pickAndUploadImage(picker, ImageSource.gallery),
                  ),
                  _buildSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: "Camera",
                    onTap: () => _pickAndUploadImage(picker, ImageSource.camera),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple.shade50,
            child: Icon(icon, color: Colors.deepPurple, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImagePicker picker, ImageSource source) async {
    Navigator.pop(context);
    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() => _isLoading = true);
      File imageFile = File(pickedFile.path);

      await widget.photoService.uploadProfileImage(imageFile);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildAvatarImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      final user = widget.authService.currentUser;
      final displayName = user?.displayName ?? "User";
      return CircleAvatar(
        radius: 56,
        backgroundColor: Colors.deepPurple.shade100,
        child: Text(
          displayName.isNotEmpty ? displayName[0].toUpperCase() : "?",
          style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
      );
    }

    try {
      final base64Content = base64String.split(',')[1];
      return CircleAvatar(
        radius: 56,
        backgroundImage: MemoryImage(base64.decode(base64Content)),
      );
    } catch (e) {
      return CircleAvatar(
        radius: 56,
        backgroundColor: Colors.red.shade100,
        child: const Icon(Icons.broken_image_rounded, color: Colors.red, size: 28),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authService.currentUser;
    final emailAddress = user?.email ?? "No Email";

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : StreamBuilder<DocumentSnapshot>(
              stream: _userStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
                }

                String? firestorePhotoUrl;
                String displayName = user?.displayName ?? "User";

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  if (data != null) {
                    firestorePhotoUrl = data['profileImage'] as String?;
                    if (data['username'] != null) {
                      displayName = data['username'] as String;
                    }
                  }
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: _buildAvatarImage(firestorePhotoUrl),
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: _showPhotoSourceBottomSheet,
                                child: const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.deepPurple,
                                  child: Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(displayName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      Text(emailAddress, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 32),

                      _buildSectionHeading("Account Information"),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade100)),
                        child: Column(
                          children: [
                            _buildMenuRow(
                              icon: Icons.person_rounded,
                              title: "Username",
                              trailingText: displayName,
                              onTap: () => _showEditNameDialog(displayName),
                            ),
                            Divider(height: 1, color: Colors.grey.shade100, indent: 56),
                            _buildMenuRow(
                              icon: Icons.email_rounded,
                              title: "Email",
                              trailingText: emailAddress,
                              onTap: null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildSectionHeading("Security"),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade100)),
                        child: _buildMenuRow(
                          icon: Icons.lock_rounded,
                          title: "Reset Password",
                          trailingText: "Send Link",
                          onTap: () async {
                            if (user?.email != null) {
                              setState(() => _isLoading = true);
                              await widget.authService.resetPassword(email: user!.email!);
                              if (!mounted) return;
                              setState(() => _isLoading = false);
                                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Password reset link sent!")),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: TextButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout_rounded, color: Colors.deepPurple),
                          label: const Text("Log Out", style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade50,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: TextButton.icon(
                          onPressed: _showDeleteAccountDialog,
                          icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
                          label: const Text("Delete Account", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSectionHeading(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.1),
        ),
      ),
    );
  }

  Widget _buildMenuRow({
    required IconData icon,
    required String title,
    required String trailingText,
    required VoidCallback? onTap,
  }) {
    return ListTileTheme(
      data: const ListTileThemeData(visualDensity: VisualDensity.compact),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.deepPurple.shade50, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.deepPurple, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText.isNotEmpty)
              Text(
                trailingText.length > 22 ? '${trailingText.substring(0, 19)}...' : trailingText,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            if (onTap != null) ...[
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
            ]
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Your Name';
  String userTitle = 'Your Title';
  String? userEmail;
  bool isEditingName = false;
  bool isEditingTitle = false;
  bool isEditingLinks = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _githubController = TextEditingController();

  // Social media URLs
  String websiteUrl = 'https://example.com';
  String linkedinUrl = 'https://linkedin.com/in/yourprofile';
  String githubUrl = 'https://github.com/yourusername';

  // Notification settings
  bool pushNotifications = true;
  bool emailNotifications = false;
  bool profileUpdates = true;

  // Privacy settings
  String profileVisibility = 'Public';
  String contactInfo = 'Private';
  String activityStatus = 'Public';

  String? userBio;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString('currentUserEmail');
    
    if (currentEmail != null) {
      // Load data specific to the current user
      setState(() {
        userEmail = currentEmail;
        userName = prefs.getString('${currentEmail}_userName') ?? 'Your Name';
        userTitle = prefs.getString('${currentEmail}_userTitle') ?? 'Your Title';
        userBio = prefs.getString('${currentEmail}_userBio');
        websiteUrl = prefs.getString('${currentEmail}_websiteUrl') ?? 'https://example.com';
        linkedinUrl = prefs.getString('${currentEmail}_linkedinUrl') ?? 'https://linkedin.com/in/yourprofile';
        githubUrl = prefs.getString('${currentEmail}_githubUrl') ?? 'https://github.com/yourusername';
        
        // Load notification settings
        pushNotifications = prefs.getBool('${currentEmail}_pushNotifications') ?? true;
        emailNotifications = prefs.getBool('${currentEmail}_emailNotifications') ?? false;
        profileUpdates = prefs.getBool('${currentEmail}_profileUpdates') ?? true;
        
        // Load privacy settings
        profileVisibility = prefs.getString('${currentEmail}_profileVisibility') ?? 'Public';
        contactInfo = prefs.getString('${currentEmail}_contactInfo') ?? 'Private';
        activityStatus = prefs.getString('${currentEmail}_activityStatus') ?? 'Public';
        
        // Set controller values
        _nameController.text = userName;
        _titleController.text = userTitle;
        _websiteController.text = websiteUrl;
        _linkedinController.text = linkedinUrl;
        _githubController.text = githubUrl;
      });
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final currentEmail = prefs.getString('currentUserEmail');
    
    if (currentEmail != null) {
      // Save data specific to the current user
      await prefs.setString('${currentEmail}_userName', userName);
      await prefs.setString('${currentEmail}_userTitle', userTitle);
      if (userBio != null) {
        await prefs.setString('${currentEmail}_userBio', userBio!);
      }
      await prefs.setString('${currentEmail}_websiteUrl', websiteUrl);
      await prefs.setString('${currentEmail}_linkedinUrl', linkedinUrl);
      await prefs.setString('${currentEmail}_githubUrl', githubUrl);
      
      // Save notification settings
      await prefs.setBool('${currentEmail}_pushNotifications', pushNotifications);
      await prefs.setBool('${currentEmail}_emailNotifications', emailNotifications);
      await prefs.setBool('${currentEmail}_profileUpdates', profileUpdates);
      
      // Save privacy settings
      await prefs.setString('${currentEmail}_profileVisibility', profileVisibility);
      await prefs.setString('${currentEmail}_contactInfo', contactInfo);
      await prefs.setString('${currentEmail}_activityStatus', activityStatus);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _websiteController.dispose();
    _linkedinController.dispose();
    _githubController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWeb = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              colorScheme.surface,
              colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: true,
              expandedHeight: isSmallScreen ? 150 : 200,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withOpacity(0.3),
                        colorScheme.secondary.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
              title: const Text('Profile'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                child: Column(
                  children: [
                    _buildProfileHeader(context),
                    const SizedBox(height: 32),
                    _buildSettingsSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: isSmallScreen ? 40 : 50,
                backgroundColor: colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: isSmallScreen ? 40 : 50,
                  color: colorScheme.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    size: isSmallScreen ? 16 : 20,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isEditingName)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isSmallScreen ? 150 : 200,
                  child: TextField(
                    controller: _nameController,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      userName = _nameController.text;
                      isEditingName = false;
                    });
                    _saveUserData();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _nameController.text = userName;
                      isEditingName = false;
                    });
                  },
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    setState(() {
                      isEditingName = true;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 8),
          if (isEditingTitle)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: isSmallScreen ? 150 : 200,
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      userTitle = _titleController.text;
                      isEditingTitle = false;
                    });
                    _saveUserData();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _titleController.text = userTitle;
                      isEditingTitle = false;
                    });
                  },
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userTitle,
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {
                    setState(() {
                      isEditingTitle = true;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (isEditingLinks)
            Column(
              children: [
                _buildLinkTextField(
                  context,
                  'Website URL',
                  _websiteController,
                  Icons.language,
                ),
                const SizedBox(height: 8),
                _buildLinkTextField(
                  context,
                  'LinkedIn URL',
                  _linkedinController,
                  Icons.link,
                ),
                const SizedBox(height: 8),
                _buildLinkTextField(
                  context,
                  'GitHub URL',
                  _githubController,
                  Icons.code,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          websiteUrl = _websiteController.text;
                          linkedinUrl = _linkedinController.text;
                          githubUrl = _githubController.text;
                          isEditingLinks = false;
                        });
                        _saveUserData();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Save'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _websiteController.text = websiteUrl;
                          _linkedinController.text = linkedinUrl;
                          _githubController.text = githubUrl;
                          isEditingLinks = false;
                        });
                      },
                      icon: const Icon(Icons.close),
                      label: const Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSocialButton(
                  context,
                  Icons.language,
                  'Website',
                  () => _launchUrl(websiteUrl),
                ),
                _buildSocialButton(
                  context,
                  Icons.link,
                  'LinkedIn',
                  () => _launchUrl(linkedinUrl),
                ),
                _buildSocialButton(
                  context,
                  Icons.code,
                  'GitHub',
                  () => _launchUrl(githubUrl),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditingLinks = true;
                    });
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: isSmallScreen ? 16 : 20),
        label: Text(
          label,
          style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          backgroundColor: colorScheme.primary.withOpacity(0.1),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 8 : 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _loadUserData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings refreshed'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                tooltip: 'Refresh Settings',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            context,
            'Edit Profile',
            Icons.edit,
            () => _showEditProfileDialog(context),
          ),
          _buildSettingsItem(
            context,
            'Notification Settings',
            Icons.notifications,
            () => _showNotificationSettings(context),
          ),
          _buildSettingsItem(
            context,
            'Privacy Settings',
            Icons.security,
            () => _showPrivacySettings(context),
          ),
          _buildSettingsItem(
            context,
            'Help & Support',
            Icons.help,
            () => _showHelpAndSupport(context),
          ),
          _buildSettingsItem(
            context,
            'Logout',
            Icons.logout,
            () => _showLogoutConfirmation(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notification Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildNotificationSwitch(
                  'Push Notifications',
                  pushNotifications,
                  (value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
                _buildNotificationSwitch(
                  'Email Notifications',
                  emailNotifications,
                  (value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),
                _buildNotificationSwitch(
                  'Profile Updates',
                  profileUpdates,
                  (value) {
                    setState(() {
                      profileUpdates = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveUserData();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification settings saved'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationSwitch(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildPrivacyOption(
                  'Profile Visibility',
                  profileVisibility,
                  Icons.visibility,
                  () {
                    setState(() {
                      profileVisibility = profileVisibility == 'Public' ? 'Private' : 'Public';
                    });
                  },
                ),
                _buildPrivacyOption(
                  'Contact Information',
                  contactInfo,
                  Icons.contact_phone,
                  () {
                    setState(() {
                      contactInfo = contactInfo == 'Public' ? 'Private' : 'Public';
                    });
                  },
                ),
                _buildPrivacyOption(
                  'Activity Status',
                  activityStatus,
                  Icons.access_time,
                  () {
                    setState(() {
                      activityStatus = activityStatus == 'Public' ? 'Private' : 'Public';
                    });
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveUserData();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Privacy settings saved'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPrivacyOption(
    String title,
    String status,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        status,
        style: TextStyle(
          color: status == 'Public' ? Colors.green : Colors.grey,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showHelpAndSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildHelpOption(
              'FAQ',
              Icons.question_answer,
              () {
                // Handle FAQ tap
              },
            ),
            _buildHelpOption(
              'Contact Support',
              Icons.support_agent,
              () {
                // Handle contact support tap
              },
            ),
            _buildHelpOption(
              'Report an Issue',
              Icons.bug_report,
              () {
                // Handle report issue tap
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Close the dialog
                Navigator.pop(context);
                
                // Show loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text('Logging out...'),
                      ],
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Clear shared preferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Navigate to login screen and clear all previous routes
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error during logout: ${e.toString()}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : colorScheme.primary,
        size: isSmallScreen ? 20 : 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontSize: isSmallScreen ? 14 : 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (title == 'Edit Profile') {
          _showEditProfileDialog(context);
        } else {
          onTap();
        }
      },
      contentPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 16,
        vertical: isSmallScreen ? 4 : 8,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: userName);
    final TextEditingController titleController = TextEditingController(text: userTitle);
    final TextEditingController bioController = TextEditingController(text: userBio ?? '');
    bool isEditing = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Edit Profile'),
                IconButton(
                  icon: Icon(
                    isEditing ? Icons.save : Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    if (isEditing) {
                      // Save changes
                      this.setState(() {
                        userName = nameController.text;
                        userTitle = titleController.text;
                        userBio = bioController.text;
                      });
                      _saveUserData();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      setState(() {
                        isEditing = true;
                      });
                    }
                  },
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Stack(
                      children: [
                        Icon(
                          Icons.person,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        if (isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    enabled: isEditing,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      prefixIcon: const Icon(Icons.work),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: bioController,
                    enabled: isEditing,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            this.setState(() {
                              userName = nameController.text;
                              userTitle = titleController.text;
                              userBio = bioController.text;
                            });
                            _saveUserData();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLinkTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
} 
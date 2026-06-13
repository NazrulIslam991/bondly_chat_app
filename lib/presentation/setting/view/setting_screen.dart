import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **************************************************************************
/// PREMIUM CHAT-CENTRIC SETTINGS SCREEN ARCHITECTURE
/// **************************************************************************
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  /// **************************************************************************
  /// STATE MANAGEMENT FOR CHAT PREFERENCES
  /// **************************************************************************
  bool _isOnlineStatusHidden = false;
  bool _isTwoFactorEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      /// **************************************************************************
      /// APP BAR: MINIMALIST CHAT APP STYLE
      /// **************************************************************************
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_2_rounded,
              color: Colors.greenAccent,
            ),
            onPressed: () {
              // Open personal profile QR code overlay
            },
          ),
        ],
      ),

      /// **************************************************************************
      /// MAIN SCROLLABLE SETTINGS VIEW
      /// **************************************************************************
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          /// **************************************************************************
          /// CHAT PROFILE AVATAR & STATUS HEADER
          /// **************************************************************************
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 2.r,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundImage: const NetworkImage(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&auto=format&fit=crop&q=80',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4.r,
                      right: 4.r,
                      child: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black,
                          size: 16.r,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '+880 1XXX-XXXXXX',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14.sp,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Hey there! I am using this amazing app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 13.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),

          /// **************************************************************************
          /// SECTION 1: CORE CHAT MESSAGING CONTROLS
          /// **************************************************************************
          _buildSectionTitle('Chat Settings'),
          _buildSettingsGroup([
            _buildSettingsTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chats',
              subtitle: 'Theme, wallpapers, chat history, backup',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications & Sounds',
              subtitle: 'Message, group & call tones',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.data_usage_rounded,
              title: 'Storage & Data',
              subtitle: 'Network usage, auto-media download',
              onTap: () {},
            ),
          ]),
          SizedBox(height: 20.h),

          /// **************************************************************************
          /// SECTION 2: PRIVACY & SECURITY NODES
          /// **************************************************************************
          _buildSectionTitle('Privacy & Account'),
          _buildSettingsGroup([
            _buildToggleTile(
              icon: Icons.visibility_off_outlined,
              title: 'Hide Last Seen / Online',
              subtitle: 'Control who can see your activity status',
              value: _isOnlineStatusHidden,
              onChanged: (val) => setState(() => _isOnlineStatusHidden = val),
            ),
            _buildToggleTile(
              icon: Icons.verified_user_outlined,
              title: 'Two-Step Verification',
              subtitle: 'Require a PIN when registering again',
              value: _isTwoFactorEnabled,
              onChanged: (val) => setState(() => _isTwoFactorEnabled = val),
            ),
            _buildSettingsTile(
              icon: Icons.devices_rounded,
              title: 'Linked Devices',
              subtitle: 'Manage your active web/desktop sessions',
              trailingText: '2 Active',
              onTap: () {},
            ),
          ]),
          SizedBox(height: 20.h),

          /// **************************************************************************
          /// SECTION 3: UTILITIES & LEGAL
          /// **************************************************************************
          _buildSectionTitle('Utilities'),
          _buildSettingsGroup([
            _buildSettingsTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & Support',
              subtitle: 'FAQ, contact support, terms of service',
              onTap: () {},
            ),
            _buildSettingsTile(
              icon: Icons.people_outline_rounded,
              title: 'Invite a Friend',
              subtitle: 'Share installation package link',
              onTap: () {},
            ),
          ]),
          SizedBox(height: 32.h),

          /// **************************************************************************
          /// LOGOUT/DISCONNECT SYSTEM ACTION
          /// **************************************************************************
          Center(
            child: TextButton.icon(
              onPressed: () {
                // Terminate token session
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: Text(
                'Log Out Account',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  /// **************************************************************************
  /// REUSABLE SUB-SECTION TITLE CAPTION
  /// **************************************************************************
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  /// **************************************************************************
  /// GROUP CONTAINER WRAPPER PACKET
  /// **************************************************************************
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          if (index == children.length - 1) return children[index];
          return Column(
            children: [
              children[index],
              const Divider(color: Colors.white10, height: 1, thickness: 0.8),
            ],
          );
        }),
      ),
    );
  }

  /// **************************************************************************
  /// ATOM COMPONENT: STANDARD NAVIGATION SETTINGS TILE WITH SUBTITLE
  /// **************************************************************************
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.r),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.5.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              margin: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withAlpha(30),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                trailingText,
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white24,
            size: 14,
          ),
        ],
      ),
    );
  }

  /// **************************************************************************
  /// ATOM COMPONENT: INTERACTIVE SWITCH TOGGLE TILE WITH SUBTITLE
  /// **************************************************************************
  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.r),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.5.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: Colors.greenAccent,
        activeTrackColor: Colors.greenAccent.withAlpha(50),
        inactiveThumbColor: Colors.white54,
        inactiveTrackColor: Colors.white10,
        onChanged: onChanged,
      ),
    );
  }
}

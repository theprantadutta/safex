import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileScreen extends StatefulWidget {
  static const String kRouteName = '/profile';

  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  bool _biometricEnabled = true;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildAccountSection(),
                  SizedBox(height: 20),
                  _buildSecuritySection(),
                  SizedBox(height: 20),
                  _buildPreferencesSection(),
                  SizedBox(height: 20),
                  _buildSupportSection(),
                  SizedBox(height: 20),
                  _buildLogoutButton(),
                  // SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              _buildProfileImage(),
              SizedBox(height: 16),
              _buildUserInfo(),
              SizedBox(height: 16),
              _buildVerificationBadge(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 48,
                // backgroundColor: Colors.white,
                // child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pravatar.cc/150?img=12',
                    fit: BoxFit.cover,
                    width: 96,
                    height: 96,
                  ),
                ),
              ),
            )
            .animate()
            .scale(delay: 300.ms, duration: 600.ms, curve: Curves.elasticOut)
            .fadeIn(delay: 200.ms),
        Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            )
            .animate()
            .scale(delay: 800.ms, duration: 400.ms)
            .fadeIn(delay: 700.ms),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
              "John Doe",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideX(begin: -0.3, end: 0, delay: 400.ms, duration: 600.ms),
        SizedBox(height: 4),
        Text("john.doe@safex.com", style: TextStyle(fontSize: 16))
            .animate()
            .fadeIn(delay: 500.ms, duration: 600.ms)
            .slideX(begin: 0.3, end: 0, delay: 500.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF4CAF50),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                "Verified Account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
        .animate()
        .scale(delay: 600.ms, duration: 500.ms, curve: Curves.elasticOut)
        .fadeIn(delay: 600.ms);
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: "Account",
      icon: Icons.person_outline,
      children: [
        _buildMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: "Payment Methods",
          subtitle: "Manage cards & bank accounts",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.currency_exchange,
          title: "Wallets & Currencies",
          subtitle: "View balances & exchange rates",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.trending_up,
          title: "Transaction Limits",
          subtitle: "Current: \$50,000/month",
          trailing: _buildUpgradeBadge(),
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: "Download Statement",
          subtitle: "Export your transaction history",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return _buildSection(
      title: "Security & Privacy",
      icon: Icons.security,
      children: [
        _buildMenuItem(
          icon: Icons.lock_outline,
          title: "Change Password",
          subtitle: "Update your login credentials",
          onTap: () {},
        ),
        _buildSwitchMenuItem(
          icon: Icons.fingerprint,
          title: "Biometric Login",
          subtitle: "Use Face ID or fingerprint",
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() {
              _biometricEnabled = value;
            });
          },
        ),
        _buildMenuItem(
          icon: Icons.phone_android,
          title: "Two-Factor Authentication",
          subtitle: "Extra security for your account",
          trailing: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "ON",
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.devices,
          title: "Manage Devices",
          subtitle: "View and revoke access",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: "Preferences",
      icon: Icons.tune,
      children: [
        _buildSwitchMenuItem(
          icon: Icons.notifications_outlined,
          title: "Push Notifications",
          subtitle: "Transaction alerts & updates",
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        _buildMenuItem(
          icon: Icons.language,
          title: "Language",
          subtitle: "English (US)",
          onTap: () {},
        ),
        _buildSwitchMenuItem(
          icon: Icons.dark_mode_outlined,
          title: "Dark Mode",
          subtitle: "Toggle dark theme",
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
            });
          },
        ),
        _buildMenuItem(
          icon: Icons.public,
          title: "Region",
          subtitle: "United States",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: "Support & Legal",
      icon: Icons.help_outline,
      children: [
        _buildMenuItem(
          icon: Icons.quiz_outlined,
          title: "Help Center",
          subtitle: "FAQs and guides",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.chat_bubble_outline,
          title: "Contact Support",
          subtitle: "Get help from our team",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.description,
          title: "Terms & Privacy",
          subtitle: "Legal documents",
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: "About SafeX",
          subtitle: "Version 2.1.4",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              ...children.map(
                (child) => child
                    .animate()
                    .fadeIn(delay: (children.indexOf(child) * 100 + 200).ms)
                    .slideX(
                      begin: -0.1,
                      end: 0,
                      delay: (children.indexOf(child) * 100 + 200).ms,
                    ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 600.ms);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.grey[600], size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.grey[600], size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF667eea),
          ),
        ],
      ),
    );
  }

  Widget _buildUpgradeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "UPGRADE",
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF6B6B).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                _showLogoutDialog();
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 800.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0, delay: 800.ms, duration: 600.ms);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF6B6B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Reusable Components for other screens
class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final double? height;
  final EdgeInsets? padding;

  const GradientCard({
    super.key,
    required this.child,
    this.colors,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors ?? [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (colors?.first ?? Color(0xFF667eea)).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor ?? Colors.grey[600], size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            )
          : null,
      trailing:
          trailing ??
          Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
      onTap: onTap,
    );
  }
}

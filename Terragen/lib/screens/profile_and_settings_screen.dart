import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';
import '../repositories/auth_repository.dart';

class ProfileAndSettingsScreen extends StatefulWidget {
  final String langCode;
  final VoidCallback onToggleLanguage;

  const ProfileAndSettingsScreen({
    super.key,
    required this.langCode,
    required this.onToggleLanguage,
  });

  @override
  State<ProfileAndSettingsScreen> createState() => _ProfileAndSettingsScreenState();
}

class _ProfileAndSettingsScreenState extends State<ProfileAndSettingsScreen> {
  final AuthRepository _authRepo = AuthRepository();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _farmNameController;
  late TextEditingController _locationController;
  late TextEditingController _soilTypeController;

  @override
  void initState() {
    super.initState();
    final u = _authRepo.currentUser;
    _nameController = TextEditingController(text: u?.fullName ?? '');
    _farmNameController = TextEditingController(text: u?.farmName ?? '');
    _locationController = TextEditingController(text: u?.farmLocation ?? '');
    _soilTypeController = TextEditingController(text: u?.soilType ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _farmNameController.dispose();
    _locationController.dispose();
    _soilTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.langCode;
    final user = _authRepo.currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.get(lang, 'farmerProfile'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {
                          if (_isEditing && user != null) {
                            _authRepo.updateProfile(
                              user.copyWith(
                                fullName: _nameController.text,
                                farmName: _farmNameController.text,
                                farmLocation: _locationController.text,
                                soilType: _soilTypeController.text,
                              ),
                            );
                          }
                          setState(() => _isEditing = !_isEditing);
                        },
                        child: Text(_isEditing ? 'Save' : 'Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (_isEditing) ...[
                    TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlinedInputBorder())),
                    const SizedBox(height: 8),
                    TextField(controller: _farmNameController, decoration: const InputDecoration(labelText: 'Farm Name', border: OutlinedInputBorder())),
                    const SizedBox(height: 8),
                    TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location', border: OutlinedInputBorder())),
                    const SizedBox(height: 8),
                    TextField(controller: _soilTypeController, decoration: const InputDecoration(labelText: 'Soil Type', border: OutlinedInputBorder())),
                  ] else ...[
                    _buildProfileItem(Icons.person, 'Name', user?.fullName ?? ''),
                    _buildProfileItem(Icons.agriculture, 'Farm Name', user?.farmName ?? ''),
                    _buildProfileItem(Icons.location_on, 'Location', user?.farmLocation ?? ''),
                    _buildProfileItem(Icons.science, 'Soil Type', user?.soilType ?? ''),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Language Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.green),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.get(lang, 'language'), style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            lang == 'ta' ? 'தற்போதைய மொழி: தமிழ்' : 'Current Language: English',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: widget.onToggleLanguage,
                    child: Text(lang == 'ta' ? AppStrings.get(lang, 'switchToEnglish') : AppStrings.get(lang, 'switchToTamil')),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Educational Resources & FAQs
          Text(AppStrings.get(lang, 'helpCenter'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ExpansionTile(
            leading: const Icon(Icons.book, color: Colors.green),
            title: Text(AppStrings.get(lang, 'soilTestingGuide')),
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Insert IoT sensor nodes 15 cm deep into moist root zone soil. Ensure solid soil contact away from stones.'),
              )
            ],
          ),

          ExpansionTile(
            leading: const Icon(Icons.science, color: Colors.blue),
            title: Text(AppStrings.get(lang, 'npkGuide')),
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Nitrogen (N) promotes vegetative growth. Phosphorus (P) accelerates root & flower development. Potassium (K) enhances disease resistance & grain filling.'),
              )
            ],
          ),

          ExpansionTile(
            leading: const Icon(Icons.help, color: Colors.orange),
            title: Text(AppStrings.get(lang, 'faqs')),
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Q: How often does telemetry update?\nA: Nodes stream telemetry every 15 minutes or on demand via the app refresh button.'),
              )
            ],
          ),

          const SizedBox(height: 24),

          // Logout
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
              onPressed: () => _authRepo.logout(),
              icon: const Icon(Icons.logout),
              label: Text(AppStrings.get(lang, 'logout')),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

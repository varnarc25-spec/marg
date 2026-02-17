import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../data/models/user_profile.dart';
import '../../../../data/models/personal_data.dart';
import '../widgets/scan_id_card_sheet.dart';

/// Personal Data - Edit: Full Name, DOB, Gender, Mobile (read-only), Email (read-only), Addresses, Nationality
const Color _editPurple = Color(0xFF6C63FF);

class PersonalDataEditScreen extends ConsumerStatefulWidget {
  const PersonalDataEditScreen({super.key});

  @override
  ConsumerState<PersonalDataEditScreen> createState() => _PersonalDataEditScreenState();
}

class _PersonalDataEditScreenState extends ConsumerState<PersonalDataEditScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _fatherNameController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _currentAddressController;
  late TextEditingController _permanentAddressController;
  late TextEditingController _nationalityController;
  String? _gender;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _fatherNameController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _currentAddressController = TextEditingController();
    _permanentAddressController = TextEditingController();
    _nationalityController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _dateOfBirthController.dispose();
    _currentAddressController.dispose();
    _permanentAddressController.dispose();
    _nationalityController.dispose();
    super.dispose();
  }

  void _applyPersonalData(PersonalData? apiData, UserProfile? profile, String? sessionEmail, String? sessionPhone) {
    if (_initialized) return;
    if (apiData != null) {
      _fullNameController.text = apiData.fullName ?? '';
      _fatherNameController.text = apiData.fatherName ?? '';
      _dateOfBirthController.text = apiData.dateOfBirth ?? '';
      _gender = apiData.gender;
      _currentAddressController.text = apiData.currentAddress ?? '';
      _permanentAddressController.text = apiData.permanentAddress ?? '';
      _nationalityController.text = apiData.nationality ?? '';
    } else if (profile != null) {
      _fullNameController.text = profile.name;
      _fatherNameController.text = profile.fatherName ?? '';
      _dateOfBirthController.text = profile.dateOfBirth ?? '';
      _gender = profile.gender;
      _currentAddressController.text = profile.currentAddress ?? '';
      _permanentAddressController.text = profile.permanentAddress ?? '';
      _nationalityController.text = profile.nationality ?? '';
    }
    _initialized = true;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _editPurple),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _editPurple.withValues(alpha: 0.6)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _editPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalDataAsync = ref.watch(personalDataFromApiProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final session = ref.watch(userSessionProvider);
    final email = session?.email ?? '';
    final phone = session?.phoneNumber ?? '';

    final apiData = personalDataAsync.valueOrNull;
    final profile = profileAsync.valueOrNull;
    _applyPersonalData(apiData, profile, session?.email, session?.phoneNumber);

    final isLoading = profileAsync.isLoading && profile == null;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Personal Data'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return profileAsync.when(
      loading: () => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Personal Data'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Scaffold(
        appBar: AppBar(title: const Text('Personal Data')),
        body: const Center(child: Text('Failed to load profile')),
      ),
      data: (profile) {

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Personal Data'),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 48,
                              backgroundColor: _editPurple.withValues(alpha: 0.15),
                              child: Text(
                                _fullNameController.text.isNotEmpty
                                    ? _fullNameController.text[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _editPurple,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Scan PAN / Aadhaar
                        _ScanIdCardChip(
                          onScan: () async {
                            final api = ref.read(margApiServiceProvider);
                            final authService = ref.read(firebaseAuthServiceProvider);
                            final user = authService.getCurrentUser();
                            final idToken = user != null ? await user.getIdToken() : null;
                            final result = await showScanIdCardSheet(
                              context,
                              margApi: api,
                              idToken: idToken,
                            );
                            if (result == null || !mounted) return;
                            setState(() {
                              if (result.fullName != null && result.fullName!.isNotEmpty) {
                                _fullNameController.text = result.fullName!;
                              }
                              if (result.dateOfBirth != null && result.dateOfBirth!.isNotEmpty) {
                                _dateOfBirthController.text = result.dateOfBirth!;
                              }
                              if (result.gender != null && result.gender!.isNotEmpty) {
                                _gender = result.gender;
                              }
                              if (result.address != null && result.address!.isNotEmpty) {
                                _currentAddressController.text = result.address!;
                                _permanentAddressController.text = result.address!;
                              }
                            });
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Details filled from ID card. Please verify and save.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        // Full Name (as per ID)
                        _label('Full Name (as per ID)'),
                        TextField(
                          controller: _fullNameController,
                          onChanged: (_) => setState(() {}),
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        // Father's Name
                        _label("Father's Name"),
                        TextField(
                          controller: _fatherNameController,
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        // Date of Birth
                        _label('Date of Birth'),
                        TextField(
                          controller: _dateOfBirthController,
                          decoration: _inputDecoration().copyWith(
                            hintText: 'e.g. 1990-05-15',
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Gender (optional)
                        _label('Gender (optional)'),
                        DropdownButtonFormField<String>(
                          value: _gender,
                          decoration: _inputDecoration(),
                          hint: const Text('Select'),
                          items: const [
                            DropdownMenuItem(value: 'Male', child: Text('Male')),
                            DropdownMenuItem(value: 'Female', child: Text('Female')),
                            DropdownMenuItem(value: 'Other', child: Text('Other')),
                            DropdownMenuItem(
                              value: 'Prefer not to say',
                              child: Text('Prefer not to say'),
                            ),
                          ],
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                        const SizedBox(height: 20),
                        // Mobile Number (OTP verification) - read-only
                        _label('Mobile Number (OTP verification)'),
                        _ReadOnlyField(value: phone.isNotEmpty ? phone : '—'),
                        const SizedBox(height: 20),
                        // Email Address - read-only
                        _label('Email Address'),
                        _ReadOnlyField(value: email.isNotEmpty ? email : '—'),
                        const SizedBox(height: 20),
                        // Current Address
                        _label('Residential Address (current)'),
                        TextField(
                          controller: _currentAddressController,
                          maxLines: 3,
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        // Permanent Address
                        _label('Residential Address (permanent)'),
                        TextField(
                          controller: _permanentAddressController,
                          maxLines: 3,
                          decoration: _inputDecoration(),
                        ),
                        const SizedBox(height: 20),
                        // Nationality
                        _label('Nationality'),
                        TextField(
                          controller: _nationalityController,
                          decoration: _inputDecoration().copyWith(
                            hintText: 'e.g. Indian',
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        final authService = ref.read(firebaseAuthServiceProvider);
                        final user = authService.getCurrentUser();
                        final idToken = user != null ? await user.getIdToken() : null;

                        if (idToken != null && idToken.isNotEmpty) {
                          final api = ref.read(margApiServiceProvider);
                          await api.savePersonalData(
                            idToken: idToken,
                            payload: {
                              'fullName': _fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim(),
                              'fatherName': _fatherNameController.text.trim().isEmpty ? null : _fatherNameController.text.trim(),
                              'dateOfBirth': _dateOfBirthController.text.trim().isEmpty ? null : _dateOfBirthController.text.trim(),
                              'gender': _gender,
                              'mobileNumber': phone.isEmpty ? null : phone,
                              'email': email.isEmpty ? null : email,
                              'currentAddress': _currentAddressController.text.trim().isEmpty ? null : _currentAddressController.text.trim(),
                              'permanentAddress': _permanentAddressController.text.trim().isEmpty ? null : _permanentAddressController.text.trim(),
                              'nationality': _nationalityController.text.trim().isEmpty ? null : _nationalityController.text.trim(),
                            },
                          );
                          ref.invalidate(personalDataFromApiProvider);
                        } else {
                          final repo = ref.read(mockDataRepositoryProvider);
                          final updated = profile.copyWith(
                            name: _fullNameController.text.trim(),
                            fatherName: _fatherNameController.text.trim().isEmpty ? null : _fatherNameController.text.trim(),
                            dateOfBirth: _dateOfBirthController.text.trim().isEmpty ? null : _dateOfBirthController.text.trim(),
                            gender: _gender,
                            currentAddress: _currentAddressController.text.trim().isEmpty ? null : _currentAddressController.text.trim(),
                            permanentAddress: _permanentAddressController.text.trim().isEmpty ? null : _permanentAddressController.text.trim(),
                            nationality: _nationalityController.text.trim().isEmpty ? null : _nationalityController.text.trim(),
                          );
                          await repo.updateUserProfile(updated);
                          ref.invalidate(userProfileProvider);
                        }
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _editPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save Change'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;

  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _ScanIdCardChip extends StatelessWidget {
  final VoidCallback onScan;

  const _ScanIdCardChip({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _editPurple.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onScan,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _editPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.document_scanner_rounded, color: _editPurple, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scan PAN or Aadhaar',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Auto-fill name, DOB, gender & address from card',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: _editPurple),
            ],
          ),
        ),
      ),
    );
  }
}

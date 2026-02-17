import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/app_providers.dart';
import 'personal_data_edit_screen.dart';

/// Personal Data – read-only display (API when logged in, else profile + session)
const Color _dataPurple = Color(0xFF6C63FF);

class PersonalDataScreen extends ConsumerWidget {
  const PersonalDataScreen({super.key});

  static String _value(String? v) => (v != null && v.isNotEmpty) ? v : '—';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalDataAsync = ref.watch(personalDataFromApiProvider);
    final profileAsync = ref.watch(userProfileProvider);
    final session = ref.watch(userSessionProvider);

    return personalDataAsync.when(
      loading: () => _buildScaffold(
        context,
        ref,
        name: '…',
        fullName: '—',
        fatherName: '—',
        dateOfBirth: '—',
        gender: '—',
        mobileNumber: session?.phoneNumber ?? '—',
        email: session?.email ?? '—',
        currentAddress: '—',
        permanentAddress: '—',
        nationality: '—',
        showLoader: true,
      ),
      error: (_, __) => profileAsync.when(
        loading: () => _buildScaffold(context, ref, name: '…', fullName: '—', fatherName: '—', dateOfBirth: '—', gender: '—', mobileNumber: session?.phoneNumber ?? '—', email: session?.email ?? '—', currentAddress: '—', permanentAddress: '—', nationality: '—', showLoader: true),
        error: (e, __) => Scaffold(appBar: AppBar(title: const Text('Personal Data')), body: const Center(child: Text('Failed to load profile'))),
        data: (profile) => _buildScaffold(
          context,
          ref,
          name: profile.name,
          fullName: profile.name,
          fatherName: _value(profile.fatherName),
          dateOfBirth: _value(profile.dateOfBirth),
          gender: _value(profile.gender),
          mobileNumber: _value(session?.phoneNumber),
          email: _value(session?.email),
          currentAddress: _value(profile.currentAddress),
          permanentAddress: _value(profile.permanentAddress),
          nationality: _value(profile.nationality),
        ),
      ),
      data: (personalData) {
        if (personalData != null) {
          final name = personalData.fullName ?? session?.email?.split('@').first ?? session?.phoneNumber ?? 'User';
          return _buildScaffold(
            context,
            ref,
            name: name,
            fullName: _value(personalData.fullName),
            fatherName: _value(personalData.fatherName),
            dateOfBirth: _value(personalData.dateOfBirth),
            gender: _value(personalData.gender),
            mobileNumber: _value(personalData.mobileNumber ?? session?.phoneNumber),
            email: _value(personalData.email ?? session?.email),
            currentAddress: _value(personalData.currentAddress),
            permanentAddress: _value(personalData.permanentAddress),
            nationality: _value(personalData.nationality),
          );
        }
        return profileAsync.when(
          loading: () => _buildScaffold(context, ref, name: '…', fullName: '—', fatherName: '—', dateOfBirth: '—', gender: '—', mobileNumber: session?.phoneNumber ?? '—', email: session?.email ?? '—', currentAddress: '—', permanentAddress: '—', nationality: '—', showLoader: true),
          error: (_, __) => Scaffold(appBar: AppBar(title: const Text('Personal Data')), body: const Center(child: Text('Failed to load profile'))),
          data: (profile) => _buildScaffold(
            context,
            ref,
            name: profile.name,
            fullName: profile.name,
            fatherName: _value(profile.fatherName),
            dateOfBirth: _value(profile.dateOfBirth),
            gender: _value(profile.gender),
            mobileNumber: _value(session?.phoneNumber),
            email: _value(session?.email),
            currentAddress: _value(profile.currentAddress),
            permanentAddress: _value(profile.permanentAddress),
            nationality: _value(profile.nationality),
          ),
        );
      },
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    WidgetRef ref, {
    required String name,
    required String fullName,
    required String fatherName,
    required String dateOfBirth,
    required String gender,
    required String mobileNumber,
    required String email,
    required String currentAddress,
    required String permanentAddress,
    required String nationality,
    bool showLoader = false,
  }) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PersonalDataEditScreen()),
              );
            },
          ),
        ],
      ),
      body: showLoader
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: _dataPurple.withValues(alpha: 0.15),
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _ReadOnlyField(label: 'Full Name (as per ID)', value: fullName),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: "Father's Name", value: fatherName),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Date of Birth', value: dateOfBirth),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Gender', value: gender),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Mobile Number (OTP verification)', value: mobileNumber),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Email Address', value: email),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Residential Address (current)', value: currentAddress),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Residential Address (permanent)', value: permanentAddress),
                    const SizedBox(height: 20),
                    _ReadOnlyField(label: 'Nationality', value: nationality),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String value;

  const _ReadOnlyField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 8),
        Container(
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
        ),
      ],
    );
  }
}

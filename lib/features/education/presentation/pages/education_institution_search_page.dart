import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/education_institution.dart';
import '../providers/education_provider.dart';
import 'education_student_profile_page.dart';

class EducationInstitutionSearchPage extends ConsumerStatefulWidget {
  const EducationInstitutionSearchPage({super.key});

  @override
  ConsumerState<EducationInstitutionSearchPage> createState() => _EducationInstitutionSearchPageState();
}

class _EducationInstitutionSearchPageState extends ConsumerState<EducationInstitutionSearchPage> {
  final _queryController = TextEditingController();
  List<EducationInstitution> _results = [];
  bool _loading = false;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: const Text('Education fees'), backgroundColor: AppColors.surfaceLight, foregroundColor: AppColors.textPrimary),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _queryController,
            decoration: const InputDecoration(hintText: 'Search school / college'),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _search, child: const Text('Search')),
          const SizedBox(height: 16),
          if (_loading) const Center(child: CircularProgressIndicator()),
          if (!_loading && _results.isNotEmpty)
            ..._results.map((r) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(r.name),
                subtitle: Text(r.type),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref.read(selectedEducationInstitutionProvider.notifier).state = r;
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EducationStudentProfilePage()));
                },
              ),
            )),
        ],
      ),
    );
  }

  void _search() async {
    setState(() => _loading = true);
    final list = await ref.read(educationRepositoryProvider).searchInstitutions(_queryController.text);
    if (mounted) {
      setState(() {
        _results = list;
        _loading = false;
      });
    }
  }
}

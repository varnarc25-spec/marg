import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'ai_assistant_chat_page.dart';

/// AI Assistant entry: Zyno AI icon, description, input field, suggested prompts.
/// Uses app theme and widgets style.
class AiAssistantPage extends StatefulWidget {
  const AiAssistantPage({super.key});

  @override
  State<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends State<AiAssistantPage> {
  final _queryController = TextEditingController();
  final _focusNode = FocusNode();

  static const List<String> _suggestedPrompts = [
    'How can I build an emergency fund?',
    "What's the best budgeting method for me?",
    'How do I reduce my spending?',
    'How do I start small investments?',
  ];

  @override
  void dispose() {
    _queryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _openChat(String query) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AiAssistantChatPage(initialQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI Assistant',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                const SizedBox(height: 32),
                _AiIconWithRipples(colorScheme: colorScheme),
                const SizedBox(height: 24),
                Text(
                  'Ask Zyno AI anything about your savings and financial improvement.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
          _InputAndSuggested(
            queryController: _queryController,
            focusNode: _focusNode,
            suggestedPrompts: _suggestedPrompts,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onSend: () {
              final q = _queryController.text.trim();
              if (q.isNotEmpty) {
                _openChat(q);
                _queryController.clear();
              }
            },
            onSuggestedTap: _openChat,
          ),
        ],
      ),
    );
  }
}

class _AiIconWithRipples extends StatelessWidget {
  const _AiIconWithRipples({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 3; i >= 1; i--) ...[
            Container(
              width: 120.0 + (i * 24.0),
              height: 120.0 + (i * 24.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withValues(
                    alpha: 0.12 - (i * 0.03),
                  ),
                  width: 1,
                ),
              ),
            ),
          ],
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.iconTilePastelPurple,
                  colorScheme.primary.withValues(alpha: 0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.iconTilePastelPurple.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputAndSuggested extends StatelessWidget {
  const _InputAndSuggested({
    required this.queryController,
    required this.focusNode,
    required this.suggestedPrompts,
    required this.colorScheme,
    required this.textTheme,
    required this.onSend,
    required this.onSuggestedTap,
  });

  final TextEditingController queryController;
  final FocusNode focusNode;
  final List<String> suggestedPrompts;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onSend;
  final void Function(String) onSuggestedTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.auto_awesome_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Ask AI anything',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      onSubmitted: (_) => onSend(),
                    ),
                  ),
                  Icon(
                    Icons.alternate_email_rounded,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: onSend,
                    icon: Icon(
                      Icons.send_rounded,
                      color: colorScheme.primary,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Suggested',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            ...suggestedPrompts.map(
              (prompt) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => onSuggestedTap(prompt),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              prompt,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

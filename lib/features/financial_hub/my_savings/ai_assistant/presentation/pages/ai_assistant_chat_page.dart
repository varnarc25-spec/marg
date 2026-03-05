import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../../../core/theme/app_theme.dart';

/// AI Assistant chat: user message bubble, AI response with steps, input + suggested.
/// Uses app theme and widget style.
class AiAssistantChatPage extends StatefulWidget {
  const AiAssistantChatPage({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<AiAssistantChatPage> createState() => _AiAssistantChatPageState();
}

class _AiAssistantChatPageState extends State<AiAssistantChatPage> {
  final _queryController = TextEditingController();
  final _scrollController = ScrollController();

  static const List<String> _suggestedPrompts = [
    'How can I build an emergency fund?',
    "What's the best budgeting method for me?",
  ];

  /// Mock AI response for car savings goal; for other queries show a generic reply.
  String _getAiResponse(String query) {
    if (query.toLowerCase().contains('car') ||
        query.toLowerCase().contains('10000') ||
        query.toLowerCase().contains('10,000') ||
        query.toLowerCase().contains('january')) {
      return '''Here's a simplified plan to save ₹10,000 for a car by January next year.

1. **Set the Goal:** Save ₹770/month over 13 months.

2. **Analyze Your Budget:** Calculate income and expenses. Ensure at least ₹770 is left for savings monthly.

3. **Cut Costs:** Reduce non-essential spending (dining, subscriptions). Automate ₹770 savings each month.

4. **Boost Income:** Consider side gigs or extra work to add to savings.

5. **Monitor Progress:** Track savings monthly and adjust if needed.''';
    }
    return '''Here’s a concise approach:

1. **Define your goal** – Set a clear amount and date.
2. **Review budget** – Income vs expenses, find a monthly savings amount.
3. **Trim spending** – Cut non-essentials and automate savings.
4. **Increase income** – Side income if needed.
5. **Track monthly** – Review and adjust as you go.''';
  }

  void _copyResponse(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Copied to clipboard'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final aiResponse = _getAiResponse(widget.initialQuery);

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
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                _UserBubble(
                  text: widget.initialQuery,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),
                _AiResponseBubble(
                  text: aiResponse,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  onCopy: () => _copyResponse(aiResponse),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          _ChatInputBar(
            queryController: _queryController,
            suggestedPrompts: _suggestedPrompts,
            colorScheme: colorScheme,
            textTheme: textTheme,
            onSuggestedTap: (String q) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => AiAssistantChatPage(initialQuery: q),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({
    required this.text,
    required this.colorScheme,
    required this.textTheme,
  });

  final String text;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.iconTilePastelPurple.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.iconTilePastelPurple.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                text,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.edit_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _AiResponseBubble extends StatelessWidget {
  const _AiResponseBubble({
    required this.text,
    required this.colorScheme,
    required this.textTheme,
    required this.onCopy,
  });

  final String text;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final paragraphs = text.split('\n\n');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...paragraphs.map((p) {
            if (p.trim().isEmpty) return const SizedBox(height: 8);
            final lines = p.split('\n');
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _parseParagraph(lines, colorScheme, textTheme),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.volume_up_rounded,
                  size: 22,
                  color: colorScheme.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              IconButton(
                onPressed: onCopy,
                icon: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const Spacer(),
              Text(
                'AI Assistance',
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _parseParagraph(
    List<String> lines,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final children = <Widget>[];
    for (final line in lines) {
      final t = line.trim();
      if (t.isEmpty) continue;
      final stepMatch = RegExp(r'^(\d+)\.\s*(.+)$').firstMatch(t);
      if (stepMatch != null) {
        final content = stepMatch.group(2)!;
        final boldMatch = RegExp(
          r'^\*\*(.+?)\*\*:\s*(.*)$',
        ).firstMatch(content);
        if (boldMatch != null) {
          final baseStyle = textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          );
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: RichText(
                text: TextSpan(
                  style: baseStyle,
                  children: [
                    TextSpan(
                      text: '${boldMatch.group(1)!}: ',
                      style: baseStyle?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(
                      text: boldMatch.group(2),
                      style: baseStyle?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          children.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                content,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          );
        }
      } else {
        children.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              t.startsWith('•') ? t : '• $t',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.queryController,
    required this.suggestedPrompts,
    required this.colorScheme,
    required this.textTheme,
    required this.onSuggestedTap,
  });

  final TextEditingController queryController;
  final List<String> suggestedPrompts;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final void Function(String) onSuggestedTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
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
                    Icons.auto_awesome_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: queryController,
                      decoration: InputDecoration(
                        hintText: 'Ask me',
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
                    ),
                  ),
                  Icon(
                    Icons.attach_file_rounded,
                    size: 22,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.send_rounded,
                    size: 24,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Suggested',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: suggestedPrompts.take(2).map((prompt) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(
                            prompt.length > 28
                                ? '${prompt.substring(0, 26)}...'
                                : prompt,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

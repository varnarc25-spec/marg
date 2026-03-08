import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_AiMessage> _messages = [];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('AI Assistant'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildHeroBadge(theme),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Ask Marg AI anything about your savings, budgeting, and financial improvement.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              Expanded(
                child: _messages.isEmpty
                    ? _buildSuggestions(theme)
                    : _buildChat(theme),
              ),
              const Divider(height: 1),
              _buildInputBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBadge(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return SizedBox(
      height: 140,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Concentric circles
            for (final radius in [120.0, 96.0, 74.0, 56.0])
              Container(
                width: radius,
                height: radius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.06),
                  ),
                ),
              ),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primary,
                    AppColors.iconTilePastelPurple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(ThemeData theme) {
    final suggestions = [
      'How can I build an emergency fund?',
      'What’s the best budgeting method for me?',
      'How do I reduce my spending?',
      'How do I start small investments?',
    ];

    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Suggested',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemBuilder: (context, index) {
              final text = suggestions[index];
              return _SuggestionChip(
                text: text,
                onTap: () => _submitQuestion(text),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemCount: suggestions.length,
          ),
        ),
      ],
    );
  }

  Widget _buildChat(ThemeData theme) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        if (msg.isUser) {
          return _UserBubble(text: msg.text);
        }
        return _AssistantBubble(text: msg.text);
      },
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ask AI anything',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) => _submitQuestion(value),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryBlue,
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () => _submitQuestion(_controller.text),
            ),
          ),
        ],
      ),
    );
  }

  void _submitQuestion(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;
    _controller.clear();

    setState(() {
      _messages.add(_AiMessage(text: text, isUser: true));
      _messages.add(_AiMessage(text: _fakeAnswerFor(text), isUser: false));
    });

    // Scroll to bottom after a short delay to let the list build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _fakeAnswerFor(String question) {
    final q = question.toLowerCase();
    if (q.contains('emergency')) {
      return 'Here’s a simple plan to build an emergency fund:\n\n'
          '1. Set a goal of 3–6 months of essential expenses.\n'
          '2. Start with a small monthly target (even ₹1,000–₹2,000).\n'
          '3. Automate a transfer to a separate savings account.\n'
          '4. Park the money in a low‑risk, highly liquid place.\n'
          '5. Increase the amount whenever your income grows.';
    }
    if (q.contains('budget') || q.contains('spend')) {
      return 'A good starting method is the 50/30/20 rule:\n\n'
          '• 50% Needs – rent, groceries, utilities.\n'
          '• 30% Wants – eating out, shopping, subscriptions.\n'
          '• 20% Savings & debt repayment.\n\n'
          'Track one month of expenses, then map each item into these buckets to see where you can cut.';
    }
    if (q.contains('invest')) {
      return 'For starting small investments:\n\n'
          '1. First, clear high‑interest debt and build an emergency fund.\n'
          '2. Start a monthly SIP into a diversified index fund.\n'
          '3. Keep your horizon at least 5 years.\n'
          '4. Avoid trying to time the market; focus on consistency.\n'
          '5. Review once a year, not every day.';
    }
    return 'Here’s a simple plan you can start with:\n\n'
        '1. Clarify your goal and time horizon.\n'
        '2. List your monthly income and all expenses.\n'
        '3. Identify 2–3 categories where you can reduce spending.\n'
        '4. Redirect the saved amount into a separate savings or investment account.\n'
        '5. Review progress every month and adjust if needed.';
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded,
                size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 60),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, right: 40),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _AiMessage {
  _AiMessage({required this.text, required this.isUser});

  final String text;
  final bool isUser;
}


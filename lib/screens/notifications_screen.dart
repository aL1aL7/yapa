import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_notification.dart';
import '../providers/notifications_provider.dart';
import '../services/api_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  void _acknowledgeAll(BuildContext context, NotificationsProvider provider) async {
    try {
      await provider.acknowledgeAll();
    } on ApiException catch (e) {
      if (context.mounted) _showError(context, e.message);
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();
    final unread = provider.unacknowledgedCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Benachrichtigungen'),
        actions: [
          if (unread > 0)
            TextButton.icon(
              onPressed: () => _acknowledgeAll(context, provider),
              icon: const Icon(Icons.done_all),
              label: const Text('Alle bestätigen'),
            ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return RefreshIndicator(
        onRefresh: provider.load,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off,
                          size: 56,
                          color: Theme.of(context).colorScheme.error),
                      const SizedBox(height: 16),
                      Text(provider.error!, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: provider.load,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Erneut versuchen'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (provider.tasks.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.load,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: constraints.maxHeight,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_none_outlined,
                        size: 56,
                        color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    Text(
                      'Keine Benachrichtigungen vorhanden.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.load,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: provider.tasks.length,
        itemBuilder: (context, index) =>
            _TaskCard(task: provider.tasks[index]),
      ),
    );
  }
}

class _TaskCard extends StatefulWidget {
  final TaskNotification task;

  const _TaskCard({required this.task});

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _expanded = false;

  Future<void> _acknowledge() async {
    final provider = context.read<NotificationsProvider>();
    try {
      await provider.acknowledgeTask(widget.task.id);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  (IconData, Color, String) _statusInfo(String status, ThemeData theme) {
    return switch (status) {
      'SUCCESS' => (Icons.check_circle_outline, Colors.green, 'Erfolgreich'),
      'FAILURE' => (Icons.error_outline, theme.colorScheme.error, 'Fehler'),
      'STARTED' => (Icons.pending_outlined, theme.colorScheme.primary, 'Läuft'),
      'PENDING' => (Icons.schedule_outlined, theme.colorScheme.outline, 'Wartend'),
      'REVOKED' => (Icons.cancel_outlined, theme.colorScheme.outline, 'Abgebrochen'),
      _ => (Icons.info_outline, theme.colorScheme.outline, status),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final task = widget.task;
    final (icon, color, statusLabel) = _statusInfo(task.status, theme);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final date = task.dateDone ?? task.dateCreated;
    final isUnread = !task.acknowledged;
    final hasResult = task.result != null && task.result!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: isUnread
          ? theme.colorScheme.secondaryContainer.withAlpha(80)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header row ---
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.taskFileName ?? 'Unbekannte Datei',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withAlpha(30),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            statusLabel,
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: color),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _expanded
                              ? Icons.expand_less
                              : Icons.expand_more,
                          size: 18,
                          color: theme.colorScheme.outline,
                        ),
                      ],
                    ),

                    // --- Preview (collapsed) ---
                    if (!_expanded && hasResult) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.result!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // --- Full content (expanded) ---
                    if (_expanded && hasResult) ...[
                      const SizedBox(height: 8),
                      SelectableText(
                        task.result!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],

                    // --- Date row ---
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined,
                            size: 12, color: theme.colorScheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(date),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                      ],
                    ),

                    // --- Dismiss chip (expanded + unread only) ---
                    if (_expanded && isUnread) ...[
                      const SizedBox(height: 10),
                      ActionChip(
                        avatar: const Icon(Icons.check, size: 16),
                        label: const Text('Verwerfen'),
                        onPressed: _acknowledge,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

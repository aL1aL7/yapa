import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_notification.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
              onPressed: provider.acknowledgeAll,
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

class _TaskCard extends StatelessWidget {
  final TaskNotification task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.read<NotificationsProvider>();
    final (icon, color, statusLabel) = _statusInfo(task.status, theme);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final date = task.dateDone ?? task.dateCreated;
    final isUnread = !task.acknowledged;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      color: isUnread
          ? theme.colorScheme.secondaryContainer.withAlpha(80)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: isUnread ? () => provider.acknowledgeTask(task.id) : null,
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
                      ],
                    ),
                    if (task.result != null && task.result!.isNotEmpty) ...[
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined,
                            size: 12,
                            color: theme.colorScheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          dateFormat.format(date),
                          style: theme.textTheme.labelSmall
                              ?.copyWith(color: theme.colorScheme.outline),
                        ),
                        if (isUnread) ...[
                          const Spacer(),
                          Text(
                            'Tippen zum Bestätigen',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (IconData, Color, String) _statusInfo(String status, ThemeData theme) {
    return switch (status) {
      'SUCCESS' => (
          Icons.check_circle_outline,
          Colors.green,
          'Erfolgreich'
        ),
      'FAILURE' => (
          Icons.error_outline,
          theme.colorScheme.error,
          'Fehler'
        ),
      'STARTED' => (
          Icons.pending_outlined,
          theme.colorScheme.primary,
          'Läuft'
        ),
      'PENDING' => (
          Icons.schedule_outlined,
          theme.colorScheme.outline,
          'Wartend'
        ),
      'REVOKED' => (
          Icons.cancel_outlined,
          theme.colorScheme.outline,
          'Abgebrochen'
        ),
      _ => (
          Icons.info_outline,
          theme.colorScheme.outline,
          status
        ),
    };
  }
}

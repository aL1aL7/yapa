import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/document.dart';
import '../providers/documents_provider.dart';
import 'tag_chip.dart';

class DocumentCard extends StatelessWidget {
  final Document document;
  final DocumentsProvider provider;
  final VoidCallback? onTap;

  const DocumentCard({
    super.key,
    required this.document,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final correspondent = document.correspondent != null
        ? provider.correspondentById(document.correspondent!)
        : null;
    final docType = document.documentType != null
        ? provider.documentTypeById(document.documentType!)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    color: theme.colorScheme.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      document.title.isNotEmpty ? document.title : document.originalFileName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateFormat.format(document.created),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              if (correspondent != null || docType != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (correspondent != null) ...[
                      Icon(Icons.person_outline, size: 14, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        correspondent.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                    if (correspondent != null && docType != null)
                      const SizedBox(width: 12),
                    if (docType != null) ...[
                      Icon(Icons.label_outline, size: 14, color: theme.colorScheme.outline),
                      const SizedBox(width: 4),
                      Text(
                        docType.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              if (document.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: document.tags.map((tagId) {
                    final tag = provider.tagById(tagId);
                    if (tag == null) return const SizedBox.shrink();
                    return TagChip(tag: tag);
                  }).toList(),
                ),
              ],
              if (document.content != null && document.content!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  document.content!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

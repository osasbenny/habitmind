import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class NotesSection extends StatefulWidget {
  final List<Map<String, dynamic>> notes;
  final Function(String note) onAddNote;

  const NotesSection({
    super.key,
    required this.notes,
    required this.onAddNote,
  });

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  bool _isExpanded = false;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_noteController.text.trim().isNotEmpty) {
      widget.onAddNote(_noteController.text.trim());
      _noteController.clear();
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.pureWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notes (${widget.notes.length})',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: AppTheme.mediumGray,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? null : 0,
            child: _isExpanded
                ? Column(
                    children: [
                      SizedBox(height: 3.h),
                      // Add note input
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _noteController,
                              decoration: InputDecoration(
                                hintText: 'Add a reflection...',
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.h,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.borderLight,
                                    width: 1,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.borderLight,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppTheme.primaryTeal,
                                    width: 2,
                                  ),
                                ),
                              ),
                              maxLines: 2,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          GestureDetector(
                            onTap: _addNote,
                            child: Container(
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryTeal,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'add',
                                color: AppTheme.pureWhite,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      // Notes list
                      widget.notes.isEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Column(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'note_alt',
                                    color: AppTheme.mediumGray,
                                    size: 32,
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'No notes yet',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.mediumGray,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.notes.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 2.h),
                              itemBuilder: (context, index) {
                                final note = widget.notes[index];
                                return Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.softGray,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note['content'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium,
                                      ),
                                      SizedBox(height: 1.h),
                                      Text(
                                        _formatDate(note['date'] as DateTime),
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.mediumGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

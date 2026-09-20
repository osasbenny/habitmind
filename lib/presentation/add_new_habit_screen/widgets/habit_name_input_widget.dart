import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitNameInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;

  const HabitNameInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<HabitNameInputWidget> createState() => _HabitNameInputWidgetState();
}

class _HabitNameInputWidgetState extends State<HabitNameInputWidget> {
  final FocusNode _focusNode = FocusNode();
  int _characterCount = 0;
  static const int _maxCharacters = 50;

  @override
  void initState() {
    super.initState();
    _characterCount = widget.controller.text.length;
    widget.controller.addListener(_updateCharacterCount);

    // Auto-focus when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCharacterCount);
    _focusNode.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = widget.controller.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;
    final bool isValid =
        _characterCount > 0 && _characterCount <= _maxCharacters && !hasError;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habit Name',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLength: _maxCharacters,
              inputFormatters: [
                LengthLimitingTextInputFormatter(_maxCharacters),
              ],
              onChanged: widget.onChanged,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Enter your habit name...',
                hintStyle: AppTheme.lightTheme.inputDecorationTheme.hintStyle,
                fillColor: AppTheme.lightTheme.colorScheme.surface,
                filled: true,
                counterText: '',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: hasError
                        ? AppTheme.errorRed
                        : isValid
                            ? AppTheme.primaryTeal
                            : AppTheme.borderLight,
                    width: hasError || isValid ? 2.0 : 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: hasError
                        ? AppTheme.errorRed
                        : isValid
                            ? AppTheme.primaryTeal
                            : AppTheme.borderLight,
                    width: hasError || isValid ? 2.0 : 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: hasError ? AppTheme.errorRed : AppTheme.primaryTeal,
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: AppTheme.errorRed,
                    width: 2.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: AppTheme.errorRed,
                    width: 2.0,
                  ),
                ),
                suffixIcon: isValid
                    ? Container(
                        margin: EdgeInsets.all(1.w),
                        decoration: const BoxDecoration(
                          color: AppTheme.primaryTeal,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.pureWhite,
                          size: 16,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.errorText != null
                  ? Expanded(
                      child: Text(
                        widget.errorText!,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.errorRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              Text(
                '$_characterCount/$_maxCharacters',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _characterCount > _maxCharacters
                      ? AppTheme.errorRed
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

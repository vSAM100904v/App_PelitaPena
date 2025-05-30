import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pa2_kelompok07/core/helpers/hooks/messangger.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_hook.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/config.dart' as Routes;

class ReportBottomSheet {
  static void show({
    required BuildContext context,
    required String currentRole,
    required String sourceId, // id dari pengirim (sentBy)
    required String chatMessageId,
    required String messageContent,
    required String authToken,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ReportBottomSheetContent(
          currentRole: currentRole,
          sourceId: sourceId,
          chatMessageId: chatMessageId,
          messageContent: messageContent,
          authToken: authToken,
        );
      },
    );
  }
}

class _ReportBottomSheetContent extends StatefulWidget {
  final String currentRole;
  final String sourceId;
  final String chatMessageId;
  final String messageContent;
  final String authToken;

  const _ReportBottomSheetContent({
    required this.currentRole,
    required this.sourceId,
    required this.chatMessageId,
    required this.messageContent,
    required this.authToken,
  });

  @override
  State<_ReportBottomSheetContent> createState() =>
      _ReportBottomSheetContentState();
}

class _ReportBottomSheetContentState extends State<_ReportBottomSheetContent> {
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _submitReport() async {
    if (_notesController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter your report notes')));
      return;
    }

    setState(() => _isSubmitting = true);
    final Map<String, dynamic> bodyMap = {
      if (widget.currentRole != 'admin')
        'admin_id': int.parse(widget.sourceId)
      else
        'client_id': int.parse(widget.sourceId),
      'chat_message_id': widget.chatMessageId,
      'message_content': widget.messageContent,
      'notes': _notesController.text,
    };

    final String body = jsonEncode(bodyMap);
    print("INI NILAI DARI BODY REQUEST" + body);
    try {
      final response = await http.post(
        Uri.parse(
          widget.currentRole == 'admin'
              ? Routes.Config.apiUrl + Routes.Config.reportUserMessageRouter
              : Routes.Config.apiUrl + Routes.Config.reportAdminMessageRouter,
        ),
        headers: {
          'Authorization': 'Bearer ${widget.authToken}',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print("INI NILAI DARI RESPONSE BODY" + response.body);
      if (mounted) {
        if (response.statusCode == 200) {
          CustomMessenger.show(
            context: context,
            message:
                widget.currentRole == 'admin'
                    ? 'Notification sent to client'
                    : 'Report submitted successfully',
            isSuccess: true,
          );
          Navigator.pop(context);
        } else if (response.statusCode == 409) {
          CustomMessenger.show(
            context: context,
            message:
                jsonDecode(response.body)["message"] ??
                "Laporan telah dibuat sebelumnya",
            isSuccess: true,
          );
          Navigator.pop(context);
        } else {
          CustomMessenger.show(
            context: context,
            message:
                widget.currentRole == 'admin'
                    ? 'Failed to send notification'
                    : 'Failed to submit report',
            isSuccess: false,
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        CustomMessenger.show(
          context: context,
          message: 'Error: ${e.toString()}',
          isSuccess: false,
        );
      }
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;
    final Color primaryColor =
        widget.currentRole == 'admin'
            ? Colors.blue.shade600
            : Color(0xFF57CC99);
    return Container(
      margin: EdgeInsets.only(
        left: responsive.space(SizeScale.sm),
        right: responsive.space(SizeScale.sm),
      ), // Add margin top here(responsive.space(SizeScale.sm)),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: responsive.space(SizeScale.md),
        right: responsive.space(SizeScale.md),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(responsive.borderRadius(SizeScale.md)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.report_problem,
                color: primaryColor,
                size: responsive.fontSize(SizeScale.lg),
              ),
              SizedBox(width: responsive.space(SizeScale.sm)),
              Text(
                widget.currentRole == 'admin'
                    ? 'Report Client Message'
                    : 'Report Admin Message',
                style: textStyle.onestBold(
                  size: SizeScale.lg,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(height: responsive.space(SizeScale.md)),

          // Message preview
          Container(
            padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
            decoration: BoxDecoration(
              color: Theme.of(context).hoverColor,
              borderRadius: BorderRadius.circular(
                responsive.borderRadius(SizeScale.sm),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Message to report:',
                  style: textStyle.jakartaSansMedium(
                    size: SizeScale.sm,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                SizedBox(height: responsive.space(SizeScale.xs)),
                Text(
                  widget.messageContent.truncate(maxChars: 18),
                  style: textStyle.dmSansRegular(
                    size: SizeScale.md,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.md)),

          // Notes input
          Text(
            'Reason for reporting:',
            style: textStyle.jakartaSansMedium(
              size: SizeScale.md,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.sm)),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your reason here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  responsive.borderRadius(SizeScale.sm),
                ),
              ),
              contentPadding: EdgeInsets.all(responsive.space(SizeScale.sm)),
            ),
            style: textStyle.dmSansRegular(size: SizeScale.md),
          ),
          SizedBox(height: responsive.space(SizeScale.lg)),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: responsive.space(SizeScale.sm),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(SizeScale.sm),
                  ),
                ),
              ),
              onPressed: _isSubmitting ? null : _submitReport,
              child:
                  _isSubmitting
                      ? SizedBox(
                        width: responsive.fontSize(SizeScale.md),
                        height: responsive.fontSize(SizeScale.md),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        widget.currentRole == 'admin'
                            ? 'Send Warning to Client'
                            : 'Submit Report',
                        style: textStyle.onestBold(
                          size: SizeScale.md,
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
          SizedBox(height: responsive.space(SizeScale.sm)),
        ],
      ),
    );
  }
}

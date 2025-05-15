import 'package:flutter/material.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/model/report/emergency_contact_model.dart';
import 'package:pa2_kelompok07/services/api_service.dart';

class UpdateEmergencyContactDialog extends StatefulWidget {
  const UpdateEmergencyContactDialog({super.key});

  @override
  State<UpdateEmergencyContactDialog> createState() =>
      _UpdateEmergencyContactDialogState();
}

class _UpdateEmergencyContactDialogState
    extends State<UpdateEmergencyContactDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final APIService _apiService = APIService();
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  String? _initialPhone; // Menyimpan data awal dari fetch

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Fetch data awal hanya sekali di initState
    _fetchInitialData();
    _controller.forward();
  }

  Future<void> _fetchInitialData() async {
    try {
      final phone = await _apiService.fetchEmergencyContact();
      if (mounted) {
        setState(() {
          _initialPhone = phone;
          _phoneController.text = phone; // Set nilai awal setelah fetch
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _updateContact() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final updatedContact = EmergencyContact(phone: _phoneController.text);
      final result = await _apiService.updateEmergencyContact(updatedContact);
      if (mounted) {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle;
    final responsive = context.responsive;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Update Kontak Darurat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Isi nomor kontak darurat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nomor Hp',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF4A5568),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_initialPhone == null &&
                      _errorMessage == null) // Loading state
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(responsive.space(SizeScale.md)),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.green[400],
                        ),
                      ),
                    )
                  else if (_errorMessage != null &&
                      _initialPhone == null) // Error state
                    Container(
                      padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.sm),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[400]),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Expanded(
                            child: Text(
                              'Error: $_errorMessage',
                              style: textStyle.dmSansRegular(
                                size: SizeScale.sm,
                                color: Colors.red[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else // Data loaded state
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: '+62 813 6060 1108',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                      ),
                    ),
                  if (_errorMessage != null && _initialPhone != null) ...[
                    SizedBox(height: responsive.space(SizeScale.sm)),
                    Container(
                      padding: EdgeInsets.all(responsive.space(SizeScale.sm)),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(
                          responsive.borderRadius(SizeScale.sm),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.warning_amber_rounded,
                            size: responsive.fontSize(SizeScale.md),
                            color: Colors.red[400],
                          ),
                          SizedBox(width: responsive.space(SizeScale.sm)),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: textStyle.dmSansRegular(
                                size: SizeScale.sm,
                                color: Colors.red[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE57373),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                          minimumSize: Size(120, 45),
                        ),
                        child: Text(
                          'Batal',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed:
                            _isLoading || _initialPhone == null
                                ? null
                                : _updateContact,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF81C784),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                          minimumSize: Size(120, 45),
                        ),
                        child:
                            _isLoading
                                ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

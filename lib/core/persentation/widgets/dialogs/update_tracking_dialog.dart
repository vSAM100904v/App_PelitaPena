import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/responsive_sizes.dart';
import 'package:pa2_kelompok07/core/helpers/hooks/text_style.dart';
import 'package:pa2_kelompok07/model/report/tracking_report_model.dart';
import 'package:pa2_kelompok07/provider/report_provider.dart';
import 'package:pa2_kelompok07/utils/loading_dialog.dart';
import 'package:provider/provider.dart';

class UpdateTrackingDialog extends StatefulWidget {
  final TrackingLaporanModel tracking;
  const UpdateTrackingDialog({super.key, required this.tracking});

  @override
  State<UpdateTrackingDialog> createState() => _UpdateTrackingDialogState();
}

class _UpdateTrackingDialogState extends State<UpdateTrackingDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late String keterangan;
  List<File> documents = [];
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    keterangan = widget.tracking.keterangan;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() {
        documents.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final textStyle = context.textStyle;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(responsive.borderRadius(SizeScale.sm)),
            ),
          ),
          elevation: 8,
          title: Text(
            'Update Tracking',
            style: textStyle.onestBold(size: SizeScale.lg),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: keterangan,
                  decoration: InputDecoration(
                    labelText: 'Keterangan',
                    labelStyle: textStyle.jakartaSansMedium(size: SizeScale.sm),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        responsive.borderRadius(SizeScale.xs),
                      ),
                    ),
                  ),
                  style: textStyle.dmSansRegular(size: SizeScale.md),
                  onSaved: (value) => keterangan = value ?? '',
                ),
                SizedBox(height: responsive.space(SizeScale.md)),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child:
                      documents.isEmpty
                          ? ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  responsive.borderRadius(SizeScale.xs),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.space(SizeScale.md),
                                vertical: responsive.space(SizeScale.sm),
                              ),
                            ),
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.image,
                              size: responsive.fontSize(SizeScale.md),
                            ),
                            label: Text(
                              'Pilih Gambar',
                              style: textStyle.jakartaSansMedium(
                                size: SizeScale.md,
                                color: Colors.white,
                              ),
                            ),
                          )
                          : Column(
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      responsive.borderRadius(SizeScale.xs),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: responsive.space(SizeScale.md),
                                    vertical: responsive.space(SizeScale.sm),
                                  ),
                                ),
                                onPressed: _pickImage,
                                icon: Icon(
                                  Icons.add_photo_alternate,
                                  size: responsive.fontSize(SizeScale.md),
                                ),
                                label: Text(
                                  'Tambah Gambar (${documents.length})',
                                  style: textStyle.jakartaSansMedium(
                                    size: SizeScale.md,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: responsive.space(SizeScale.sm)),
                              SizedBox(
                                height: responsive.space(SizeScale.xxl),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: documents.length,
                                  itemBuilder:
                                      (context, index) => Padding(
                                        padding: EdgeInsets.only(
                                          right: responsive.space(SizeScale.sm),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    responsive.borderRadius(
                                                      SizeScale.xs,
                                                    ),
                                                  ),
                                              child: Image.file(
                                                documents[index],
                                                width: responsive.space(
                                                  SizeScale.xxl,
                                                ),
                                                height: responsive.space(
                                                  SizeScale.xxl,
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    documents.removeAt(index);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          responsive
                                                              .borderRadius(
                                                                SizeScale.xs,
                                                              ),
                                                        ),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: responsive.fontSize(
                                                      SizeScale.sm,
                                                    ),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                            ],
                          ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
                textStyle: textStyle.jakartaSansMedium(size: SizeScale.md),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(SizeScale.xs),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.space(SizeScale.md),
                  vertical: responsive.space(SizeScale.sm),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  showLoadingDialog(context);
                  await Provider.of<ReportProvider>(
                    context,
                    listen: false,
                  ).updateTracking(
                    id: widget.tracking.id.toString(),
                    keterangan: keterangan,
                    documents: documents,
                  );
                  closeLoadingDialog(context);
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Update',
                style: textStyle.jakartaSansMedium(
                  size: SizeScale.md,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

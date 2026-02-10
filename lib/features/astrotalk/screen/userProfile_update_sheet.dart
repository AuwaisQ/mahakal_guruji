import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mahakal/data/datasource/remote/http/httpClient.dart' as http_service;

class UserProfileUpdateSheet extends StatefulWidget {
  final String userId;
  final Function(String gender, String dob, String tob, String pob)
      onProfileUpdate;

  const UserProfileUpdateSheet(
      {required this.userId, required this.onProfileUpdate});

  @override
  State<UserProfileUpdateSheet> createState() =>
      _UserProfileUpdateSheetState();
}

class _UserProfileUpdateSheetState extends State<UserProfileUpdateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _genderCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _tobCtrl = TextEditingController();
  final _pobCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _genderCtrl.dispose();
    _dobCtrl.dispose();
    _tobCtrl.dispose();
    _pobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobCtrl.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _tobCtrl.text = picked.format(context);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final body = {
      'user_id': widget.userId,
      'gender': _genderCtrl.text.trim(),
      'dob': _dobCtrl.text.trim(),
      'tob': _tobCtrl.text.trim(),
      'pob': _pobCtrl.text.trim(),
    };

    try {
      final res = await http_service.HttpService()
          .postApi('/api/v1/customer/astro-user-profile-update', body);
      if (mounted) {
        if (res != null && res['success'] == true) {
          widget.onProfileUpdate(
            _genderCtrl.text.trim(),
            _dobCtrl.text.trim(),
            _tobCtrl.text.trim(),
            _pobCtrl.text.trim(),
          );
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Profile updated');
        } else {
          Fluttertoast.showToast(msg: res?['message'] ?? 'Update failed');
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error updating profile');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: null,
                  items: const [
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (v) {
                    _genderCtrl.text = v ?? '';
                  },
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Select gender' : null,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'YYYY-MM-DD',
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Choose DOB' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tobCtrl,
                  readOnly: true,
                  onTap: _pickTime,
                  decoration: const InputDecoration(
                    labelText: 'Time of Birth',
                    hintText: 'e.g. 10:30 AM',
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Choose TOB' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _pobCtrl,
                  decoration: const InputDecoration(labelText: 'Place of Birth'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter POB' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _isSubmitting
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _submit,
                              child: const Text('Save & Continue'),
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
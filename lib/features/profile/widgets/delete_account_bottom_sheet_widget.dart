import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/features/profile/controllers/profile_contrroller.dart';
import 'package:mahakal/localization/language_constrants.dart';
import 'package:mahakal/utill/custom_themes.dart';
import 'package:mahakal/utill/dimensions.dart';
import 'package:mahakal/utill/images.dart';
import 'package:mahakal/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  final String customerId;
  const DeleteAccountBottomSheet({super.key, required this.customerId});

  void showMahakalAccountDeleteDialog(BuildContext context) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Account from Mahakal.com?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Are you sure you want to delete account from Mahakal.com?'),
                SizedBox(height: 12),
                Text(
                  'On Deleting the account, all data will be permanently deleted.\n'
                  'After successful deletion we will not be able to retrieve any data.',
                  style: TextStyle(color: Colors.red),
                ),
                SizedBox(height: 12),
                Text(
                  'Data Deleted:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('• Account Information'),
                Text('• Profile Photo'),
                Text('• All Orders'),
                Text('• Wallet Transactions'),
                Text('• Support Tickets or Chat'),
                Text('• Any pending payments will be cancelled automatically'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your account deletion logic here
                Navigator.pop(context); // Close the confirmation dialog
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AccountDeletionReasonScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('YES, DELETE'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        // User pressed YES, DELETE
        // Add your deletion logic here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account deletion process initiated'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40, top: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(Dimensions.paddingSizeDefault))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(.5),
                borderRadius: BorderRadius.circular(20)),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimensions.paddingSizeDefault),
            child: SizedBox(width: 60, child: Image.asset(Images.delete)),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeSmall,
          ),
          Text(
            getTranslated('delete_account', context)!,
            style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: Dimensions.paddingSizeSmall,
                bottom: Dimensions.paddingSizeLarge),
            child: Text('${getTranslated('want_to_delete_account', context)}'),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeOverLarge),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 120,
                    child: CustomButton(
                      buttonText: '${getTranslated('cancel', context)}',
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .tertiaryContainer
                          .withOpacity(.5),
                      textColor: Theme.of(context).textTheme.bodyLarge?.color,
                      onTap: () => Navigator.pop(context),
                    )),
                const SizedBox(
                  width: Dimensions.paddingSizeDefault,
                ),
                SizedBox(
                    width: 120,
                    child: CustomButton(
                        buttonText: '${getTranslated('delete', context)}',
                        backgroundColor: Theme.of(context).colorScheme.error,
                        onTap: () {
                          showMahakalAccountDeleteDialog(context);

                          // Provider.of<ProfileController>(context, listen: false).deleteCustomerAccount(context, int.parse(customerId)).then((condition) {
                          //   if(condition.response!.statusCode == 200){
                          //     Navigator.pop(context);
                          //     Provider.of<AuthController>(context,listen: false).clearSharedData();
                          //     Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => const AuthScreen()), (route) => false);
                          //   }
                          // });
                        }))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AccountDeletionReasonScreen extends StatefulWidget {
  const AccountDeletionReasonScreen({
    super.key,
  });

  @override
  State<AccountDeletionReasonScreen> createState() =>
      _AccountDeletionReasonScreenState();
}

class _AccountDeletionReasonScreenState
    extends State<AccountDeletionReasonScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _phoneVerified = false;
  String userPHONE = "";

  @override
  void initState() {
    super.initState();
    userPHONE =
        Provider.of<ProfileController>(Get.context!, listen: false).userPHONE;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() {
    if (_phoneController.text.trim() == userPHONE) {
      setState(() {
        _phoneVerified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number verified successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _phoneVerified = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number does not match registered number'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Account Deletion'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'We\'re sorry to see you go',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Mahakal.com',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),

              // Reason input
              const Text(
                'Please tell us why you\'re leaving:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonController,
                maxLines: 5,
                minLines: 3,
                decoration: InputDecoration(
                  hintText: 'Your feedback helps us improve...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a reason';
                  }
                  if (value.length < 10) {
                    return 'Please provide more details';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Minimum 10 characters required',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),

              // Phone verification
              const Text(
                'Verify your registered phone number:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Enter registered phone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (!_phoneVerified) {
                          return 'Please verify phone number $userPHONE';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _verifyPhoneNumber,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_phoneVerified)
                Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Phone number verified',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _phoneVerified
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                _confirmDeletion(context);
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey[400],
                      ),
                      child: const Text(
                        'DELETE CONFIRM',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: const Text(
          'This will permanently delete your account and all associated data. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close reason screen
              _performAccountDeletion(_reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  void _performAccountDeletion(String reason) {
    // Implement your account deletion logic here
    // You can send the reason and verified phone to your backend

    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deleted successfully'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to home or login screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

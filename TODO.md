# TODO: Turn off all notifications except calling notifications

## Tasks
- [x] Modify `lib/push_notification/notification_helper.dart` - Add early return for non-call types in `onMessage.listen()`
- [x] Modify `lib/push_notification/notification_helper.dart` - Add early return for non-call types in `onMessageOpenedApp.listen()`
- [x] Modify `lib/push_notification/notification_helper.dart` - `myBackgroundMessageHandler()` was already updated in the same file

## Summary of Changes

All notifications except calling notifications have been disabled. The app will now only show notifications for:
- `audio` - Audio calls
- `video` - Video calls  
- `chat` - Chat calls

All other notification types are silently ignored:
- `notification` - General notifications
- `order` - Order notifications
- `wallet` - Wallet notifications
- `block` - Account block notifications (Note: This was removed for consistency)
- `chadhava`, `puja`, `vip`, `anushthan`, `offlinepuja`, `consultancy`, `event`, `darshan`, `tour`, `donation`, `product` - Service-specific notifications

## Files Modified
1. `lib/push_notification/notification_helper.dart` - Updated `onMessage.listen()`, `onMessageOpenedApp.listen()`, and `myBackgroundMessageHandler()` to only process call types

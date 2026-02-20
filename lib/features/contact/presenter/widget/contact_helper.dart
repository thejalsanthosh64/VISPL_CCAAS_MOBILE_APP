import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:kommuno/features/contact/data/model/contact_list_request_model.dart';
import 'package:kommuno/features/contact/data/model/server_contact_response_model.dart';
import 'package:kommuno/features/contact/data/repository/contact_repo.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactLookup {
  static Map<String, String> serverNames = {};
  // static Map<String, String> deviceNames = {};

static String normalize(String number) {
  // Remove invisible RTL/LTR formatting characters
  number = number.replaceAll(RegExp(r'[\u202A\u202B\u202C\u202D\u202E\u2066\u2067\u2068\u2069]'), "");

  // Remove spaces, dashes, plus
  String result = number
      .replaceAll(" ", "")
      .replaceAll("-", "")
      .replaceAll("+", "")
      .trim();

  // Remove 91 country code
  if (result.startsWith("91") && result.length > 10) {
    result = result.substring(2);
  }

  debugPrint(" ContactLookup.normalize CLEAN: '$number' → '$result'");
  return result;
}


  static String getName(String number) {
    if (number.isEmpty) {
      debugPrint(" ContactLookup.getName: Empty number provided");
      return "Unknown";
    }

    final n = normalize(number);
    
    debugPrint(" ContactLookup.getName: Looking up '$n'");
    debugPrint(" Server names map has ${serverNames.length} entries");
    // debugPrint(" Device names map has ${deviceNames.length} entries");

    // Check server names first (business contacts)
    if (serverNames.containsKey(n) && serverNames[n]!.isNotEmpty) {
      debugPrint(" Found in server names: ${serverNames[n]}");
      return serverNames[n]!;
    }
    
    // Then check device contacts
    // if (deviceNames.containsKey(n) && deviceNames[n]!.isNotEmpty) {
    //   debugPrint(" Found in device names: ${deviceNames[n]}");
    //   return deviceNames[n]!;
    // }

    debugPrint(" Not found in either map. Returning 'Unknown'");
    debugPrint(" Sample server keys: ${serverNames.keys.take(5).toList()}");
    // debugPrint(" Sample device keys: ${deviceNames.keys.take(5).toList()}");
    
    return "Unknown";
  }

  // Add a contact dynamically (useful for incoming calls)
  static void addContact(String number, String name) {
    if (number.isEmpty || name.isEmpty) return;
    
    final n = normalize(number);
    final cleanName = name.trim();
    
    if (cleanName.isNotEmpty && cleanName.toLowerCase() != "unknown" && cleanName.toLowerCase() != "no name") {
      // Prefer server names if they exist, otherwise use device names
      if (!serverNames.containsKey(n)) {
        serverNames[n] = cleanName;
        debugPrint(" Added to device names: $n → $cleanName");
      }
    }
  }

  // Clear all contacts (use carefully)
  static void clearAll() {
    serverNames.clear();
    // deviceNames.clear();
  }

  // Get total contact count
  static int get totalContacts => serverNames.length;
  
  // Debug: Print all contacts (use sparingly - can be verbose)
  static void printAllContacts() {
    debugPrint(" === ALL CONTACTS ===");
    debugPrint("Server names (${serverNames.length}):");
    serverNames.forEach((key, value) {
      debugPrint("  $key → $value");
    });
    // debugPrint("Device names (${deviceNames.length}):");
    // deviceNames.forEach((key, value) {
    //   debugPrint("  $key → $value");
    // });
  }
}

/// BACKGROUND CONTACT SYNC SERVICE
/// Add this as a singleton service that loads contacts silently
class ContactSync {
  static final ContactSync _instance = ContactSync._internal();
  factory ContactSync() => _instance;
  ContactSync._internal();

  bool _isInitialized = false;
  bool _isLoading = false;

  /// Initialize contacts silently in background when app starts
  Future<void> initialize({
    required BuildContext context,
    required String smeId,
    required int agentId,
  }) async {
    if (_isInitialized || _isLoading) {
      debugPrint(" ContactSync: Already initialized or loading");
      return;
    }

    _isLoading = true;
    debugPrint(" ContactSync: Starting background sync...");

    try {
      // Load both in parallel for faster initialization
      await Future.wait([
        // _loadDeviceContactsSilently(context),
        _loadServerContactsSilently(smeId),
      ]);

      _isInitialized = true;
      debugPrint(" ContactSync: Initialization complete!");
      // debugPrint("   - Device contacts: ${ContactLookup.deviceNames.length}");
      debugPrint("   - Server contacts: ${ContactLookup.serverNames.length}");
      debugPrint("   - Total: ${ContactLookup.totalContacts}");
    } catch (e) {
      debugPrint(" ContactSync: Error during initialization: $e");
    } finally {
      _isLoading = false;
    }
  }

  /// Load device contacts silently without showing any UI
  // Future<void> _loadDeviceContactsSilently(BuildContext context) async {
  //   try {
  //     // Check permission silently (don't show dialog)
  //     final hasPermission = await Permission.contacts.isGranted;

  //     if (!hasPermission) {
  //       debugPrint(" ContactSync: No contacts permission");
  //       return;
  //     }

  //     final contacts = await FlutterContacts.getContacts(
  //       withThumbnail: false, // Faster without thumbnails
  //       sorted: false, // Faster without sorting
  //       withProperties: true,
  //     );

  //     debugPrint(" ContactSync: Processing ${contacts.length} device contacts...");

  //     int added = 0;
  //     for (var contact in contacts) {
  //       if (contact.phones.isNotEmpty) {
  //         final name = contact.displayName.trim();
  //         final number = contact.phones.first.number;

  //         if (name.isNotEmpty && name.toLowerCase() != "unknown") {
  //           final normalized = ContactLookup.normalize(number);
  //           ContactLookup.deviceNames[normalized] = name;
  //           added++;
  //         }
  //       }
  //     }

  //     debugPrint(" ContactSync: Added $added device contacts");
  //   } catch (e) {
  //     debugPrint(" ContactSync: Device contacts error: $e");
  //   }
  // }

  /// Load server contacts silently without showing any UI
  Future<void> _loadServerContactsSilently(String smeId) async {
    try {
      final contactRepo = ContactRepo();
      
      // Load first batch (100 contacts should cover most cases)
      final res = await contactRepo.getAllContacts(
        getContactsRequestModel: GetContactsRequestModel(
          batchSize: 100,
          initialRecord: 1,
          smeId: smeId,
        ),
      );

      if (res.isSuccess) {
        final data = List<Map<String, dynamic>>.from(res.data as List);
        debugPrint(" ContactSync: Processing ${data.length} server contacts...");

        int added = 0;
        for (var item in data) {
          final contact = ServerContactsResponseModel.fromJson(item);
          final name = contact.customerName.trim();
          final number = contact.customerNumberPrimary;

          if (number.isNotEmpty && 
              name.isNotEmpty && 
              name.toLowerCase() != "unknown" && 
              name.toLowerCase() != "no name") {
            final normalized = ContactLookup.normalize(number);
            ContactLookup.serverNames[normalized] = name;
            added++;
          }
        }

        debugPrint(" ContactSync: Added $added server contacts");

        // If there might be more contacts, load them in background
        if (data.length >= 100) {
          _loadRemainingServerContacts(smeId, initialRecord: 101);
        }
      }
    } catch (e) {
      debugPrint(" ContactSync: Server contacts error: $e");
    }
  }

  /// Continue loading server contacts in background (optional)
  Future<void> _loadRemainingServerContacts(String smeId, {required int initialRecord}) async {
    try {
      final contactRepo = ContactRepo();
      final res = await contactRepo.getAllContacts(
        getContactsRequestModel: GetContactsRequestModel(
          batchSize: 100,
          initialRecord: initialRecord,
          smeId: smeId,
        ),
      );

      if (res.isSuccess) {
        final data = List<Map<String, dynamic>>.from(res.data as List);
        if (data.isEmpty) return;

        debugPrint(" ContactSync: Loading additional ${data.length} server contacts...");

        for (var item in data) {
          final contact = ServerContactsResponseModel.fromJson(item);
          final name = contact.customerName.trim();
          final number = contact.customerNumberPrimary;

          if (number.isNotEmpty && name.isNotEmpty) {
            ContactLookup.serverNames[ContactLookup.normalize(number)] = name;
          }
        }

        // Continue if more data available
        if (data.length >= 100) {
          await _loadRemainingServerContacts(smeId, initialRecord: initialRecord + 100);
        }
      }
    } catch (e) {
      debugPrint(" ContactSync: Additional server contacts error: $e");
    }
  }

  /// Force refresh all contacts
  Future<void> refresh({
    required BuildContext context,
    required String smeId,
    required int agentId,
  }) async {
    _isInitialized = false;
    await initialize(
      context: context,
      smeId: smeId,
      agentId: agentId,
    );
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Get stats
  String getStats() {
    return " Server: ${ContactLookup.serverNames.length} | Total: ${ContactLookup.totalContacts}";
  }
}
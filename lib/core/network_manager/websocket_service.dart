import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/presenter/page/call_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class CallWebSocketManager {
  static IO.Socket? _socket;
  static bool _isConnected = false;
  static String? _currentSessionId;

  // Initialize WebSocket connection
  static void connect({
    required String sessionId,
    required int smeId,
    required int agentId,
  }) {
    try {
      _currentSessionId = sessionId;
      
      debugPrint('🔌 Initializing WebSocket connection...');
      debugPrint('Session ID: $sessionId');
      debugPrint('SME ID: $smeId');
      debugPrint('Agent ID: $agentId');

      _socket = IO.io(
        'https://testsio.smartping.ai/',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setReconnectionAttempts(5)
            .build(),
      );

      _setupListeners(sessionId, smeId, agentId);
      
      debugPrint('WebSocket connecting...');
    } catch (e, s) {
      debugPrint(' WebSocket connection error: $e\n$s');
    }
  }

  static void _setupListeners(String sessionId, int smeId, int agentId) {
    _socket?.onConnect((_) {
      _isConnected = true;
      debugPrint(' WebSocket Connected');
      
      // Join room with session details
      final joinData = {
        'sessionId': sessionId,
        'smeId': smeId,
        'agentId': agentId,
        'type': 'agent', // Specify user type
      };
      
      debugPrint(' Joining room with: $joinData');
      _socket?.emit('join_session', joinData);
      
      // Alternative event names to try
      _socket?.emit('join', joinData);
      _socket?.emit('subscribe', joinData);
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      debugPrint(' WebSocket Disconnected');
    });

    _socket?.onConnectError((error) {
      debugPrint(' WebSocket Connection Error: $error');
    });

    _socket?.onError((error) {
      debugPrint(' WebSocket Error: $error');
    });

    _socket?.onReconnect((attempt) {
      debugPrint(' WebSocket Reconnecting... Attempt: $attempt');
    });

    _socket?.onReconnectError((error) {
      debugPrint(' WebSocket Reconnection Error: $error');
    });

    _socket?.onReconnectFailed((_) {
      debugPrint(' WebSocket Reconnection Failed');
    });

    // Listen for acknowledgment of joining
    _socket?.on('joined', (data) {
      debugPrint(' Successfully joined room: $data');
    });

    _socket?.on('room_joined', (data) {
      debugPrint('Room joined: $data');
    });

    // Listen for call events - try multiple event name variations
    _socket?.on('call_connected', (data) {
      debugPrint(' Call Connected Event: $data');
      _handleCallConnected(data);
    });

    _socket?.on('callConnected', (data) {
      debugPrint(' callConnected Event: $data');
      _handleCallConnected(data);
    });

    _socket?.on('call_ringing', (data) {
      debugPrint(' Call Ringing: $data');
      _handleCallRinging(data);
    });

    _socket?.on('call_answered', (data) {
      debugPrint(' Call Answered: $data');
      _handleCallAnswered(data);
    });

    _socket?.on('call_ended', (data) {
      debugPrint(' Call Ended: $data');
      _handleCallEnded(data);
    });

    _socket?.on('callEnded', (data) {
      debugPrint(' callEnded Event: $data');
      _handleCallEnded(data);
    });

    _socket?.on('channel_created', (data) {
      debugPrint(' Channel Created: $data');
      _handleChannelCreated(data);
    });

    _socket?.on('channelCreated', (data) {
      debugPrint(' channelCreated Event: $data');
      _handleChannelCreated(data);
    });

    _socket?.on('call_status_update', (data) {
      debugPrint(' Call Status Update: $data');
      _handleCallStatusUpdate(data);
    });

    _socket?.on('callStatus', (data) {
      debugPrint(' callStatus Event: $data');
      _handleCallStatusUpdate(data);
    });

    // Generic event listener to catch all events (for debugging)
    _socket?.onAny((event, data) {
      debugPrint(' WebSocket Event Received: $event');
      debugPrint(' Event Data: $data');
    });
  }

  static void _handleCallConnected(dynamic data) {
    try {
      debugPrint('🎯 Processing call_connected event');
      
      final channelId = data is Map ? data['channelId'] as String? : null;
      final callerName = data is Map 
          ? (data['callerName'] as String? ?? data['caller_name'] as String? ?? 'Unknown')
          : 'Unknown';
      final phoneNumber = data is Map 
          ? (data['phoneNumber'] as String? ?? data['phone_number'] as String? ?? data['to'] as String? ?? '')
          : '';

      debugPrint('Channel ID: $channelId');
      debugPrint('Caller Name: $callerName');
      debugPrint('Phone Number: $phoneNumber');

      if (channelId != null && channelId.isNotEmpty) {
        // Update CallSession with channel ID
        CallSession.save(
          session: _currentSessionId!,
          channel: channelId,
          sme: CallSession.smeId,
          agent: CallSession.agentId,
          name: CallSession.agentName,
        );
        debugPrint('CallSession updated with channelId: $channelId');
        
        // Update CallStateCubit
        final context = AppKeys.nestedNavigatorKey.currentContext;
        if (context != null) {
          context.read<CallStateCubit>().setConnected(
            callerName: callerName,
            phoneNumber: phoneNumber,
          );
          
          debugPrint(' CallStateCubit updated');
          
          // Navigate to Call Screen
          Navigator.of(AppKeys.navigatorKey.currentContext!).push(
            MaterialPageRoute(builder: (_) => const CallScreen()),
          );
          debugPrint(' Navigated to CallScreen');
        } else {
          debugPrint(' Context is null, cannot update cubit');
        }
      } else {
        debugPrint(' Channel ID is null or empty');
      }
    } catch (e, s) {
      debugPrint(' Error in _handleCallConnected: $e\n$s');
    }
  }

  static void _handleCallRinging(dynamic data) {
    debugPrint('📱 Call is ringing...');
    FToastManager().showToast(
      message: 'Call is ringing...',
    );
  }

  static void _handleCallAnswered(dynamic data) {
    try {
      debugPrint('🎯 Processing call_answered event');
      
      final callerName = data is Map 
          ? (data['callerName'] as String? ?? data['caller_name'] as String? ?? 'Unknown')
          : 'Unknown';
      final phoneNumber = data is Map 
          ? (data['phoneNumber'] as String? ?? data['phone_number'] as String? ?? data['to'] as String? ?? '')
          : '';
      
      final context = AppKeys.nestedNavigatorKey.currentContext;
      if (context != null) {
        context.read<CallStateCubit>().setConnected(
          callerName: callerName,
          phoneNumber: phoneNumber,
        );
        debugPrint(' Call answered, state updated');
      }
    } catch (e, s) {
      debugPrint(' Error in _handleCallAnswered: $e\n$s');
    }
  }

  static void _handleCallEnded(dynamic data) {
    try {
      debugPrint(' Processing call_ended event');
      
      final context = AppKeys.nestedNavigatorKey.currentContext;
      if (context != null) {
        final cubit = context.read<CallStateCubit>();
        cubit.stopTimer();
        
        // Pop call screen if active
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
          debugPrint(' Popped CallScreen');
        }
      }
      
      FToastManager().showToast(
        message: 'Call ended',
      );
      
      disconnect();
    } catch (e, s) {
      debugPrint(' Error in _handleCallEnded: $e\n$s');
    }
  }

  static void _handleChannelCreated(dynamic data) {
    try {
      debugPrint(' Processing channel_created event');
      
      final channelId = data is Map 
          ? (data['channelId'] as String? ?? data['channel_id'] as String?)
          : null;
          
      debugPrint('Channel ID from event: $channelId');
      
      if (channelId != null && channelId.isNotEmpty && _currentSessionId != null) {
        CallSession.save(
          session: _currentSessionId!,
          channel: channelId,
          sme: CallSession.smeId,
          agent: CallSession.agentId,
          name: CallSession.agentName,
        );
        debugPrint(' Channel ID saved: $channelId');
      } else {
        debugPrint(' Channel ID is null or empty');
      }
    } catch (e, s) {
      debugPrint(' Error in _handleChannelCreated: $e\n$s');
    }
  }

  static void _handleCallStatusUpdate(dynamic data) {
    try {
      debugPrint(' Processing call_status_update event');
      
      final status = data is Map ? data['status'] as String? : null;
      debugPrint('Call status updated to: $status');
      
      // Handle various status updates
      switch (status?.toLowerCase()) {
        case 'on_hold':
        case 'hold':
          debugPrint(' Call is on hold');
          break;
        case 'muted':
          debugPrint(' Call is muted');
          break;
        case 'transferred':
          debugPrint('↪ Call transferred');
          break;
        case 'connected':
          _handleCallConnected(data);
          break;
        case 'ended':
        case 'disconnected':
          _handleCallEnded(data);
          break;
        default:
          debugPrint('ℹ Unknown status: $status');
      }
    } catch (e, s) {
      debugPrint('Error in _handleCallStatusUpdate: $e\n$s');
    }
  }

  // Emit events to server
  static void emitEvent(String event, Map<String, dynamic> data) {
    if (_isConnected && _socket != null) {
      debugPrint(' Emitting event: $event with data: $data');
      _socket!.emit(event, data);
    } else {
      debugPrint(' WebSocket not connected. Cannot emit event: $event');
    }
  }

  // Disconnect
  static void disconnect() {
    if (_socket != null) {
      debugPrint(' Disconnecting WebSocket...');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _isConnected = false;
      _currentSessionId = null;
      debugPrint(' WebSocket Disconnected and Disposed');
    }
  }

  static bool get isConnected => _isConnected;
  static String? get currentSessionId => _currentSessionId;
}

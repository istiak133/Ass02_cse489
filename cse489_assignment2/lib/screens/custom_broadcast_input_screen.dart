import 'dart:async';
import 'package:flutter/material.dart';

class CustomBroadcastInputScreen extends StatefulWidget {
  const CustomBroadcastInputScreen({super.key});

  @override
  State<CustomBroadcastInputScreen> createState() =>
      _CustomBroadcastInputScreenState();
}

class _CustomBroadcastInputScreenState
    extends State<CustomBroadcastInputScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Broadcast - Input'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter a message to broadcast:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _sendBroadcast,
                icon: const Icon(Icons.send),
                label: const Text(
                  'Send Broadcast',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendBroadcast() {
    final message = _textController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message first!')),
      );
      return;
    }

    // Navigate to the receiver screen, passing the message
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBroadcastReceiverScreen(message: message),
      ),
    );
  }
}

// ====== Third Activity: Custom Broadcast Receiver ======
class CustomBroadcastReceiverScreen extends StatefulWidget {
  final String message;

  const CustomBroadcastReceiverScreen({super.key, required this.message});

  @override
  State<CustomBroadcastReceiverScreen> createState() =>
      _CustomBroadcastReceiverScreenState();
}

class _CustomBroadcastReceiverScreenState
    extends State<CustomBroadcastReceiverScreen> {
  String _receivedMessage = '';
  bool _isReceiving = true;

  @override
  void initState() {
    super.initState();
    // Simulate broadcast receiving with a small delay
    _simulateBroadcastReceive();
  }

  Future<void> _simulateBroadcastReceive() async {
    // Simulating the broadcast being sent and received
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _receivedMessage = widget.message;
        _isReceiving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Broadcast - Receiver'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isReceiving ? Icons.hourglass_top : Icons.check_circle,
                size: 64,
                color: _isReceiving ? Colors.orange : Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                _isReceiving
                    ? 'Waiting to receive broadcast...'
                    : 'Broadcast Received!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _isReceiving ? Colors.orange : Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              if (!_isReceiving) ...[
                const Text(
                  'Received Message:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    _receivedMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
              if (_isReceiving)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

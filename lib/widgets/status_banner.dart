import 'package:flutter/material.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.firebaseEnabled});

  final bool firebaseEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: firebaseEnabled ? Colors.green.shade50 : Colors.orange.shade50,
      child: Row(
        children: [
          Icon(
            firebaseEnabled ? Icons.cloud_done : Icons.warning_amber_rounded,
            color: firebaseEnabled ? Colors.green.shade800 : Colors.orange.shade900,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              firebaseEnabled
                  ? 'Firebase conectado: os favoritos são salvos no Cloud Firestore.'
                  : 'Firebase ainda não configurado. A API funciona; favoritos exigem configuração do Firebase.',
              style: TextStyle(
                color: firebaseEnabled ? Colors.green.shade900 : Colors.orange.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/payment_model.dart';

final paymentsProvider = StateNotifierProvider<PaymentsNotifier, List<Payment>>((ref) {
  return PaymentsNotifier();
});

class PaymentsNotifier extends StateNotifier<List<Payment>> {
  PaymentsNotifier() : super([
    Payment(
      id: '1',
      description: 'Assinatura Plano Pro - Mar/2026',
      amount: 79.90,
      method: PaymentMethod.subscription,
      status: PaymentStatus.completed,
      date: DateTime(2026, 2, 1),
    ),
    Payment(
      id: '2',
      description: 'Pagamento Agendamento - Cílios',
      amount: 150.00,
      method: PaymentMethod.pix,
      status: PaymentStatus.completed,
      date: DateTime(2026, 2, 10),
    ),
    Payment(
      id: '3',
      description: 'Pagamento Produto - Vape X-Pro',
      amount: 250.00,
      method: PaymentMethod.pix,
      status: PaymentStatus.pending,
      date: DateTime(2026, 2, 14),
    ),
  ]);

  void addPayment(Payment payment) {
    state = [...state, payment];
  }

  void updatePaymentStatus(String paymentId, PaymentStatus newStatus) {
    state = [for (final payment in state) if (payment.id == paymentId) payment.copyWith(status: newStatus) else payment];
  }
}

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamentos'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Histórico de Transações',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ...payments.map((payment) => _buildPaymentCard(context, payment)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPaymentSheet(context, ref),
        backgroundColor: AppTheme.accentGold,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Payment payment) {
    IconData icon;
    Color color;

    switch (payment.status) {
      case PaymentStatus.completed:
        icon = FontAwesomeIcons.checkCircle;
        color = Colors.green;
        break;
      case PaymentStatus.pending:
        icon = FontAwesomeIcons.clock;
        color = Colors.orange;
        break;
      case PaymentStatus.failed:
        icon = FontAwesomeIcons.timesCircle;
        color = Colors.red;
        break;
      case PaymentStatus.refunded:
        icon = FontAwesomeIcons.undo;
        color = Colors.blueGrey;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassCard(
        width: double.infinity,
        height: 100,
        child: ListTile(
          leading: Icon(icon, color: color, size: 24),
          title: Text(payment.description, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(
            '${DateFormat('dd/MM/yyyy').format(payment.date)} - R\$${payment.amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Icon(FontAwesomeIcons.chevronRight, color: AppTheme.textSecondary),
          onTap: () {
            // TODO: Implement payment details view
          },
        ),
      ),
    );
  }

  void _showAddPaymentSheet(BuildContext context, WidgetRef ref) {
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    PaymentMethod _selectedMethod = PaymentMethod.pix;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Novo Pagamento',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                ),
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                ),
                style: TextStyle(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<PaymentMethod>(
                value: _selectedMethod,
                decoration: InputDecoration(
                  labelText: 'Método de Pagamento',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.textSecondary.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                ),
                dropdownColor: AppTheme.background,
                style: TextStyle(color: AppTheme.textPrimary),
                items: PaymentMethod.values.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    _selectedMethod = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newPayment = Payment(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    description: _descriptionController.text,
                    amount: double.parse(_amountController.text),
                    method: _selectedMethod,
                    date: DateTime.now(),
                  );
                  ref.read(paymentsProvider.notifier).addPayment(newPayment);
                  Navigator.pop(context);
                },
                child: const Text('Adicionar Pagamento'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

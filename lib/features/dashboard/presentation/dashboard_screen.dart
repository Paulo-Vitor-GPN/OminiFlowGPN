import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/analytics_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data based on user requirements
    final summary = AnalyticsSummary(
      ticketMedio: 145.50,
      churnRate: 12.0,
      loyaltyRate: 88.0,
      topInsights: [
        BusinessInsight(
          title: 'Oportunidade de Upsell',
          description: 'Clientes de Lash Studio costumam comprar Manutenção após 18 dias.',
          value: 2500.0,
          percentageChange: 15.0,
          isPositive: true,
        ),
      ],
      criticalInventory: [
        InventoryInsight(productName: 'Cola Lash Premium', currentStock: 2, minStock: 5, turnoverRate: 0.8),
        InventoryInsight(productName: 'Cílios 0.07 D', currentStock: 3, minStock: 10, turnoverRate: 1.2),
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildKPISection(summary),
              const SizedBox(height: 30),
              _buildInventoryAlertSection(summary),
              const SizedBox(height: 30),
              _buildBusinessInsightsSection(summary),
              const SizedBox(height: 30),
              _buildRetentionChart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OminiFlow',
              style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              'Business Insights',
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: AppTheme.glassSurface,
          child: Icon(FontAwesomeIcons.user, color: AppTheme.accentGold, size: 18),
        ),
      ],
    );
  }

  Widget _buildKPISection(AnalyticsSummary summary) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GlassCard(
                width: double.infinity,
                height: 140,
                child: _buildKPICard(
                  'Ticket Médio (AOV)',
                  'R\$ ${summary.ticketMedio.toStringAsFixed(2)}',
                  '+12.5%',
                  AppTheme.accentGold,
                  FontAwesomeIcons.moneyBillTrendUp,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: GlassCard(
                width: double.infinity,
                height: 140,
                child: _buildKPICard(
                  'Taxa de Retenção',
                  '${summary.loyaltyRate}%',
                  '+4.2%',
                  AppTheme.accentBlue,
                  FontAwesomeIcons.userCheck,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String change, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color.withOpacity(0.7), size: 20),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 5),
          Text(change, style: const TextStyle(fontSize: 12, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInventoryAlertSection(AnalyticsSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Alertas de Estoque Crítico', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 15),
        ...summary.criticalInventory.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            width: double.infinity,
            height: 80,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), shape: BoxShape.circle),
                child: const Icon(FontAwesomeIcons.triangleExclamation, color: Colors.redAccent, size: 16),
              ),
              title: Text(item.productName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Apenas ${item.currentStock} unidades (Mín: ${item.minStock})'),
              trailing: Text('Giro: ${item.turnoverRate}x', style: TextStyle(color: AppTheme.accentGold, fontWeight: FontWeight.bold)),
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildBusinessInsightsSection(AnalyticsSummary summary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Insights de IA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 15),
        ...summary.topInsights.map((insight) => GlassCard(
          width: double.infinity,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(FontAwesomeIcons.lightbulb, color: AppTheme.accentGold, size: 16),
                    const SizedBox(width: 10),
                    Text(insight.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentGold)),
                  ],
                ),
                const SizedBox(height: 10),
                Text(insight.description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Potencial de Receita: R\$ ${insight.value}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildRetentionChart(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fidelidade vs Ciclo de 21 Dias', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppTheme.accentGold, width: 15)]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: AppTheme.accentBlue, width: 15)]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: AppTheme.accentGold, width: 15)]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppTheme.accentBlue, width: 15)]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: AppTheme.accentGold, width: 15)]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 30),
              _buildKPISection(context),
              const SizedBox(height: 30),
              _buildInventoryAlert(context),
              const SizedBox(height: 30),
              _buildGrowthChart(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Olá, Empreendedor',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
          ),
        ),
        Text(
          'OminiFlow Insights',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildKPISection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassCard(
            width: double.infinity,
            height: 120,
            child: _buildKPICard(
              'Ticket Médio',
              'R$ 145,50',
              '+12%',
              AppTheme.accentGold,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: GlassCard(
            width: double.infinity,
            height: 120,
            child: _buildKPICard(
              'Retenção',
              '88%',
              '+5%',
              AppTheme.accentBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String value, String change, Color color) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 5),
          Text(change, style: const TextStyle(fontSize: 12, color: Colors.greenAccent)),
        ],
      ),
    );
  }

  Widget _buildInventoryAlert(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 100,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.warning_amber_rounded, color: Colors.white),
        ),
        title: const Text('Alerta de Estoque', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text('3 itens estão abaixo do nível de segurança'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {},
      ),
    );
  }

  Widget _buildGrowthChart(BuildContext context) {
    return GlassCard(
      width: double.infinity,
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Crescimento Mensal', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(2.6, 2),
                        FlSpot(4.9, 5),
                        FlSpot(6.8, 3.1),
                        FlSpot(8, 4),
                        FlSpot(9.5, 3),
                        FlSpot(11, 4),
                      ],
                      isCurved: true,
                      color: AppTheme.accentGold,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.accentGold.withOpacity(0.1),
                      ),
                    ),
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

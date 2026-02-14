class BusinessInsight {
  final String title;
  final String description;
  final double value;
  final double percentageChange;
  final bool isPositive;

  BusinessInsight({
    required this.title,
    required this.description,
    required this.value,
    required this.percentageChange,
    required this.isPositive,
  });
}

class InventoryInsight {
  final String productName;
  final int currentStock;
  final int minStock;
  final double turnoverRate;

  InventoryInsight({
    required this.productName,
    required this.currentStock,
    required this.minStock,
    required this.turnoverRate,
  });

  bool get isCritical => currentStock <= minStock;
}

class AnalyticsSummary {
  final double ticketMedio;
  final double churnRate;
  final double loyaltyRate;
  final List<BusinessInsight> topInsights;
  final List<InventoryInsight> criticalInventory;

  AnalyticsSummary({
    required this.ticketMedio,
    required this.churnRate,
    required this.loyaltyRate,
    required this.topInsights,
    required this.criticalInventory,
  });
}

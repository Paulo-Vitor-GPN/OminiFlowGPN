import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../domain/inventory_model.dart';

final inventoryProvider = StateNotifierProvider<InventoryNotifier, List<Product>>((ref) {
  return InventoryNotifier();
});

class InventoryNotifier extends StateNotifier<List<Product>> {
  InventoryNotifier() : super([
    Product(
      id: '1',
      name: 'Cílios Volume Russo',
      description: 'Extensão de cílios volume russo',
      price: 150.0,
      quantity: 10,
      minStockLevel: 5,
    ),
    Product(
      id: '2',
      name: 'Cola para Cílios',
      description: 'Cola hipoalergênica para extensão',
      price: 80.0,
      quantity: 3,
      minStockLevel: 2,
      status: ProductStatus.lowStock,
    ),
    Product(
      id: '3',
      name: 'Cigarro Eletrônico X-Pro',
      description: 'Vape de alta performance',
      price: 250.0,
      quantity: 20,
      minStockLevel: 10,
    ),
    Product(
      id: '4',
      name: 'Essência de Morango',
      description: 'Essência para vape sabor morango',
      price: 30.0,
      quantity: 1,
      minStockLevel: 5,
      status: ProductStatus.outOfStock,
    ),
  ]);

  void addProduct(Product product) {
    state = [...state, product];
  }

  void updateProduct(Product updatedProduct) {
    state = [for (final product in state) if (product.id == updatedProduct.id) updatedProduct else product];
  }

  void removeProduct(String productId) {
    state = state.where((product) => product.id != productId).toList();
  }
}

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventory = ref.watch(inventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gerenciamento de Produtos',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 20),
            ...inventory.map((product) => _buildProductCard(context, product, ref)).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductSheet(context, ref),
        backgroundColor: AppTheme.accentGold,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, WidgetRef ref) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (product.status) {
      case ProductStatus.inStock:
        statusColor = Colors.green;
        statusIcon = FontAwesomeIcons.checkCircle;
        statusText = 'Em Estoque';
        break;
      case ProductStatus.lowStock:
        statusColor = Colors.orange;
        statusIcon = FontAwesomeIcons.exclamationCircle;
        statusText = 'Estoque Baixo';
        break;
      case ProductStatus.outOfStock:
        statusColor = Colors.red;
        statusIcon = FontAwesomeIcons.timesCircle;
        statusText = 'Fora de Estoque';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: GlassCard(
        width: double.infinity,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              Text(
                'Quantidade: ${product.quantity}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 5),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddProductSheet(BuildContext context, WidgetRef ref) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();
    final TextEditingController _minStockLevelController = TextEditingController();

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
                'Novo Produto',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
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
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Preço',
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
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
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
                controller: _minStockLevelController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nível Mínimo de Estoque',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final newProduct = Product(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: _nameController.text,
                    description: _descriptionController.text,
                    price: double.parse(_priceController.text),
                    quantity: int.parse(_quantityController.text),
                    minStockLevel: int.parse(_minStockLevelController.text),
                    status: int.parse(_quantityController.text) <= int.parse(_minStockLevelController.text) ? ProductStatus.lowStock : ProductStatus.inStock,
                  );
                  ref.read(inventoryProvider.notifier).addProduct(newProduct);
                  Navigator.pop(context);
                },
                child: const Text('Adicionar Produto'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

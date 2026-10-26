import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/widgets/build_skeleton.dart';
import 'package:prestacash/widgets/my_input_field.dart';
import '../features/auth/data/services.dart';
import '../models/customer.dart';
import '../widgets/my_loader.dart';
import 'manage_customer_screen.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Customer> _customers = [];
  String? _error;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    // Espera a que la pantalla esté dibujada para poder abrir el loader
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCustomers());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCustomers({bool showLoader = true}) async {
    if (showLoader) MyLoader.show(context, message: 'Cargando clientes...');
    try {
      final data = await customerService.getCustomers();
      if (!mounted) return;
      setState(() {
        _customers = data;
        _error = null;
        _loaded = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _loaded = true;
      });
    } finally {
      if (showLoader && mounted) MyLoader.hide(context);
    }
  }

  // Pull to refresh: sin MyLoader, porque ya tiene su propia animación
  Future<void> _refresh() => _loadCustomers(showLoader: false);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Clientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.azulMarino,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MyInputField(hint: 'Buscar cliente', prefix: Icon(Icons.search)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.azulMarino,
                  fixedSize: const Size(AppInput.height, AppInput.height),
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Icon(Icons.filter_list, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    final created = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageCustomerScreen(),
                      ),
                    );
                    if (created == true) {
                      _refresh();
                    }
                  },
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Nuevo cliente'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(55.0),
                    backgroundColor: AppColors.azulMarino,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildList(),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildContainer(Customer item) {
    final initial = item.fullName.isNotEmpty ? item.fullName[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => ManageCustomerScreen(customer: item),
          ),
        );
        if (updated == true) {
          _loadCustomers();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.azulMarino,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fullName.length > 20
                        ? '${item.fullName.substring(0, 20)}...'
                        : item.fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.azulMarino,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: AppColors.azulMarino),
                          const SizedBox(width: 4),
                          Text(
                            item.phone ?? 'Sin teléfono',
                            style: TextStyle(fontSize: 14, color: AppColors.azulMarino),
                          ),
                        ],
                      ),
                      Text(
                        item.documentNumber,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.azulMarino,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.azulMarino),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (!_loaded) return BuildSkeleton();

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.azulMarino),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _loadCustomers(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      color: AppColors.azulMarino,
      child: _customers.isEmpty
          ? ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 80),
          Center(child: Text('No hay clientes registrados')),
        ],
      )
          : ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _customers.length,
        itemBuilder: (context, index) => _buildContainer(_customers[index]),
      ),
    );
  }
}

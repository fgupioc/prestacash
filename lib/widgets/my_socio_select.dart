
import 'package:flutter/material.dart';
import 'package:prestacash/core/constants.dart';
import 'package:prestacash/models/customer.dart';

class MySocioSelect extends StatefulWidget {
  final List<Customer> socios;
  final ValueChanged<Customer?> onChanged;
  final Customer? initialValue;

  const MySocioSelect({
    super.key,
    required this.socios,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<MySocioSelect> createState() => _MySocioSelectState();
}

class _MySocioSelectState extends State<MySocioSelect> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Customer? _socioSeleccionado;
  bool _limpiando = false;

  @override
  void initState() {
    super.initState();
    _aplicarValorInicial(widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _limpiarSeleccion() {
    setState(() {
      _limpiando = true;
      _socioSeleccionado = null;
      _controller.clear();
    });

    widget.onChanged(null);

    _focusNode.unfocus();

    _limpiando = false;
  }

  @override
  void didUpdateWidget(covariant MySocioSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Por si el valor inicial llega después (ej. carga async)
    if (widget.initialValue != oldWidget.initialValue &&
        _socioSeleccionado == null) {
      _aplicarValorInicial(widget.initialValue);
    }
  }

  void _aplicarValorInicial(Customer? socio) {
    if (socio == null) return;
    _socioSeleccionado = socio;
    _controller.text = socio.fullName;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return RawAutocomplete<Customer>(
          textEditingController: _controller,
          focusNode: _focusNode,

          displayStringForOption: (socio) => socio.fullName,

          optionsBuilder: (value) {
            if (_limpiando || _socioSeleccionado != null) {
              return const Iterable<Customer>.empty();
            }

            final query = value.text.toLowerCase().trim();

            if (query.isEmpty) {
              return widget.socios;
            }

            return widget.socios.where((socio) {
              return socio.fullName
                  .toLowerCase()
                  .contains(query) ||
                  socio.documentNumber.contains(query);
            });
          },

          onSelected: (socio) {
            setState(() {
              _socioSeleccionado = socio;
            });

            widget.onChanged(socio);
            _focusNode.unfocus();
          },

          fieldViewBuilder: (
              context,
              controller,
              focusNode,
              onFieldSubmitted,
              ) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              readOnly: _socioSeleccionado != null,
              textAlignVertical: TextAlignVertical.center,

              onChanged: (_) {
                // Si se edita el texto, invalidar
                // cualquier selección anterior.
                if (_socioSeleccionado != null) {
                  setState(() {
                    _socioSeleccionado = null;
                  });
                  widget.onChanged(null);
                }
              },

              decoration: InputDecoration(
                hintText: 'Buscar socio por nombre o DNI',

                hintStyle: const TextStyle(
                  color: AppColors.azulAcero,
                  fontSize: 14,
                ),

                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.azulMarino,
                ),

                suffixIcon: _socioSeleccionado != null
                    ? IconButton(
                  tooltip: 'Quitar socio',
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.azulMarino,
                  ),
                  onPressed: _limpiarSeleccion,
                )
                    : IconButton(
                  tooltip: 'Buscar socio',
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.azulMarino,
                  ),
                  onPressed: () {
                    focusNode.requestFocus();
                  },
                ),

                filled: true,
                fillColor: Colors.white,

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.celesteClaro,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.celesteClaro,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF1673ED),
                    width: 1.5,
                  ),
                ),
              ),
            );
          },

          optionsViewBuilder: (
              context,
              onOptionSelected,
              options,
              ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),

                child: SizedBox(
                  width: constraints.maxWidth,

                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 260,
                    ),

                    child: ListView.builder(
                      padding: const EdgeInsets.all(6),
                      shrinkWrap: true,
                      itemCount: options.length,

                      itemBuilder: (context, index) {
                        final socio = options.elementAt(index);

                        return ListTile(
                          onTap: () {
                            onOptionSelected(socio);
                          },

                          leading: CircleAvatar(
                            backgroundColor:
                            AppColors.celesteClaro,

                            child: Text(
                              socio.fullName[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.azulMarino,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          title: Text(
                            socio.fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.azulNoche,
                            ),
                          ),

                          subtitle: Text(
                            'DNI: ${socio.documentNumber}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.azulAcero,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

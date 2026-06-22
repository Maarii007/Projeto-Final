import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({
    super.key,
    required this.selecionado,
    required this.onChanged,
  });
  final String selecionado;
  final ValueChanged<String> onChanged;

  static const _opcoes = [
    (valor: 'all', label: 'Todos',  icon: Icons.emoji_nature),
    (valor: 'dog', label: 'Cães',   icon: Icons.pets),
    (valor: 'cat', label: 'Gatos',  icon: Icons.nightlight_round),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _opcoes.map((o) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            selected: selecionado == o.valor,
            avatar: Icon(o.icon, size: 16),
            label: Text(o.label),
            onSelected: (_) => onChanged(o.valor),
            showCheckmark: false,
          ),
        )).toList(),
      ),
    );
  }
}

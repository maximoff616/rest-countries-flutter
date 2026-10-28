import 'package:flutter/material.dart';

import '../../models/country.dart';
import 'summary_tile.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({required this.country, super.key});

  final Country country;

  String _formatPopulation(int population) {
    if (population <= 0) return 'Not listed';
    final value = population.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < value.length; index++) {
      if (index > 0 && (value.length - index) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(value[index]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF121C2D),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: const Color(0xFF26334A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: SizedBox(
                  width: 66,
                  height: 46,
                  child: country.flagUrl.isEmpty
                      ? const ColoredBox(
                          color: Color(0xFF202D43),
                          child: Icon(Icons.flag_rounded),
                        )
                      : Image.network(
                          country.flagUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const ColoredBox(
                            color: Color(0xFF202D43),
                            child: Icon(
                              Icons.flag_rounded,
                              color: Color(0xFF9AA9C0),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${country.region} • ${country.code}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF9AA9C0),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          SummaryTile(
            icon: Icons.location_on_outlined,
            label: 'Ibu kota',
            value: country.capitalLabel,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SummaryTile(
                  icon: Icons.people_alt_outlined,
                  label: 'Populasi',
                  value: _formatPopulation(country.population),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SummaryTile(
                  icon: Icons.translate_rounded,
                  label: 'Bahasa',
                  value: country.languagesLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Color(0xFF78A6FF),
                size: 15,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  country.currenciesLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFB8C6DA),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

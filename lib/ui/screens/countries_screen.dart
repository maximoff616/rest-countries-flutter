import 'package:flutter/material.dart';

import '../../models/country.dart';
import '../../services/countries_service.dart';
import '../widgets/country_card.dart';
import '../widgets/country_search_field.dart';

class CountriesScreen extends StatefulWidget {
  const CountriesScreen({super.key});

  @override
  State<CountriesScreen> createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen> {
  final CountriesService _service = CountriesService();
  final TextEditingController _searchController = TextEditingController();

  List<Country> _countries = const [];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';
  String _selectedRegion = 'All';

  static const List<String> _regions = [
    'All',
    'Africa',
    'Americas',
    'Asia',
    'Europe',
    'Oceania',
  ];

  List<Country> get _filteredCountries {
    final query = _query.trim().toLowerCase();
    return _countries.where((country) {
      final matchesQuery = query.isEmpty ||
          country.name.toLowerCase().contains(query) ||
          country.capitalLabel.toLowerCase().contains(query) ||
          country.region.toLowerCase().contains(query) ||
          country.languagesLabel.toLowerCase().contains(query);
      final matchesRegion =
          _selectedRegion == 'All' || country.region == _selectedRegion;
      return matchesQuery && matchesRegion;
    }).toList(growable: false);
  }

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final countries = await _service.fetchCountries();
      if (!mounted) return;
      setState(() {
        _countries = countries;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error is CountriesApiException
            ? error.message
            : 'Tidak dapat memuat data. Periksa koneksi internet Anda.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCountries = _filteredCountries;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadCountries,
          color: const Color(0xFF5D91F2),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: const Color(0xFF17243A),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF283954)),
                        ),
                        child: const Icon(
                          Icons.public_rounded,
                          color: Color(0xFF78A6FF),
                          size: 25,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Country Explorer',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Discover the world, one country at a time',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9AA9C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Muat ulang data',
                        onPressed: _loadCountries,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A2B45), Color(0xFF304F7A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0xFF405D83)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.travel_explore_rounded,
                              color: Color(0xFFB6D0FF),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Your world at a glance',
                              style: TextStyle(
                                color: Color(0xFFD7E5FF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          _isLoading ? '...' : '${_countries.length}',
                          style: const TextStyle(
                            fontSize: 43,
                            height: 1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'countries to explore',
                          style: TextStyle(
                            color: Color(0xFFC3D4EF),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Find capitals, languages, populations, and currencies '
                          'from around the globe.',
                          style: TextStyle(
                            color: Color(0xFFE0E9F8),
                            height: 1.5,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: CountrySearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    onClear: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final region = _regions[index];
                      final selected = region == _selectedRegion;
                      return ChoiceChip(
                        label: Text(region),
                        selected: selected,
                        onSelected: (_) =>
                            setState(() => _selectedRegion = region),
                        showCheckmark: false,
                        selectedColor: const Color(0xFF5D91F2),
                        backgroundColor: const Color(0xFF151F32),
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF5D91F2)
                              : const Color(0xFF26334A),
                        ),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : const Color(0xFFB5C1D4),
                          fontWeight:
                              selected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Explore countries',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        _isLoading ? 'Loading...' : '${visibleCountries.length} results',
                        style: const TextStyle(
                          color: Color(0xFF9AA9C0),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _LoadingState(),
                )
              else if (_errorMessage != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _ErrorState(
                    message: _errorMessage!,
                    onRetry: _loadCountries,
                  ),
                )
              else if (visibleCountries.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.crossAxisExtent;
                      final columns = width >= 900 ? 3 : width >= 560 ? 2 : 1;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          mainAxisExtent: 270,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => CountryCard(
                            country: visibleCountries[index],
                          ),
                          childCount: visibleCountries.length,
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF78A6FF)),
            SizedBox(height: 18),
            Text('Mengambil data negara dari REST Countries...'),
            SizedBox(height: 6),
            Text(
              'Mohon tunggu sebentar.',
              style: TextStyle(color: Color(0xFF9AA9C0), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 42,
              color: Color(0xFFFF9A9A),
            ),
            const SizedBox(height: 14),
            const Text(
              'Data gagal dimuat',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9AA9C0), height: 1.5),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 42, color: Color(0xFF8294B0)),
            SizedBox(height: 14),
            Text(
              'Negara tidak ditemukan',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Coba kata kunci atau wilayah lain.',
              style: TextStyle(color: Color(0xFF9AA9C0)),
            ),
          ],
        ),
      ),
    );
  }
}

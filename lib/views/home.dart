import 'package:flutter/material.dart';
import 'package:resep_masak/model/resep.dart';
import 'package:resep_masak/model/resep.api.dart';
import 'package:resep_masak/views/detail_resep.dart';
import 'package:resep_masak/views/widget/resep_card.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Resep> _resep;
  late List<Resep> _filteredResep; // Daftar resep yang difilter berdasarkan pencarian
  bool _isLoading = true;
  String searchQuery = ""; // Query pencarian

  @override
  void initState() {
    super.initState();
    getResep();
  }

  Future<void> getResep() async {
    _resep = await ResepApi.getResep();
    setState(() {
      _filteredResep = _resep; // Awalnya semua resep ditampilkan
      _isLoading = false;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      _filteredResep = _resep
          .where((resep) => resep.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList(); // Filter resep berdasarkan nama
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(width: 10),
              Text('Resep Makanan')
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) => updateSearchQuery(value), // Memperbarui query pencarian
                decoration: InputDecoration(
                  hintText: 'Cari Resep...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _filteredResep.isEmpty
            ? Center(child: Text('Resep tidak ditemukan!'))
            : ListView.builder(
                itemCount:  _filteredResep.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ResepCard(
                      title: _filteredResep[index].name,
                      thumbnailUrl: _filteredResep[index].thumbnail_url,
                      cookTime: _filteredResep[index].cookTime,
                      videoUrl: _filteredResep[index].videoUrl,
                    ),
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailResep(
                              name: _filteredResep[index].name,
                              thumbnail_url: _filteredResep[index].thumbnail_url,
                              cookTime: _filteredResep[index].cookTime,
                              description: _filteredResep[index].description,
                              videoUrl: _filteredResep[index].videoUrl,
                              instructions: _filteredResep[index].instructions,
                              sections: _filteredResep[index].sections,
                            ),
                          ))
                    },
                  );
                }));
  }
}

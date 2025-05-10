import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Messages',
            style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.bold,
              fontFamily: 'SourceSans3',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: Colors.grey[800]),
              onPressed: () {
                // TODO: implement search
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[800]),
              onPressed: () {
                // TODO: open menu
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey[600],
            tabs: const [
              Tab(text: 'one'),
              Tab(text: 'Buying'),
              Tab(text: 'Selling'),
            ],
          ),
        ),
        body: TabBarView(
          children: const [
            _FilterTabContent(),
            _FilterTabContent(),
            _FilterTabContent(),
          ],
        ),
      ),
    );
  }
}

class _FilterTabContent extends StatefulWidget {
  const _FilterTabContent();
  @override
  __FilterTabContentState createState() => __FilterTabContentState();
}

class __FilterTabContentState extends State<_FilterTabContent> {
  static const List<String> _filters = [
    'All',
    'Meeting',
    'Important',
    'Unread',
  ];
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, idx) {
              final isSelected = idx == _selectedFilterIndex;
              return ChoiceChip(
                label: Text(_filters[idx]),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => _selectedFilterIndex = idx);
                },
                selectedColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SourceSans3',
                ),
              );
            },
          ),
        ),

        const Divider(height: 1),

        // Placeholder for list of messages
        Expanded(
          child: Center(
            child: Text(
              'Showing "${_filters[_selectedFilterIndex]}" messages',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontFamily: 'SourceSans3',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:demo_project/src/core/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateTicket extends StatefulWidget {
  const CreateTicket({super.key});

  @override
  State<CreateTicket> createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();

  List<Map<String, dynamic>> _items = [];

  final _itemBox = Hive.box('item_box');

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _itemBox.keys.map((key) {
      final item = _itemBox.get(key);
      return {
        "key": key,
        "title": item["title"],
        "subtitle": item["subtitle"],
      };
    }).toList();
    setState(() {
      _items = data.reversed.toList();
      print(_items.length);
    });
  }

  //new item
  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _itemBox.add(newItem);
    _refreshItems();
  }

  //update item
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _itemBox.put(itemKey, item);
    _refreshItems();
  }

  //delete item
  Future<void> _deleteItem(int itemKey) async {
    await _itemBox.delete(itemKey);
    _refreshItems();
    //Display SnackBar
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('An Item has been deleted')));
  }

  void _showForm(BuildContext ctx, int? itemKey) async {
    if (itemKey != null) {
      final existingItem =
          _items.firstWhere((element) => element['key'] == itemKey);
      _titleController.text = existingItem['title'];
      _subtitleController.text = existingItem['subtitle'];
    }

    showModalBottomSheet(
      context: ctx,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Enter a seat name',
                  fillColor: AppColor.fillColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColor.mainColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColor.mainColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: false,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  hintText: 'Enter a seat name',
                  fillColor: AppColor.fillColor,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColor.mainColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColor.mainColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                obscureText: false,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (itemKey == null) {
                    _createItem({
                      "title": _titleController.text,
                      "subtitle": _subtitleController.text,
                    });
                  }
                  if (itemKey != null) {
                    _updateItem(itemKey, {
                      'title': _titleController.text.trim(),
                      'subtitle': _subtitleController.text.trim(),
                    });
                  }

                  //clear textFields
                  _titleController.text = '';
                  _subtitleController.text = '';
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(itemKey == null ? 'Create New' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Item'),
      ),
      body: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (_, index) {
            final currentItem = _items[index];
            return Card(
              color: Colors.blue,
              margin: EdgeInsets.all(16.0),
              elevation: 3,
              child: ListTile(
                title: Text(currentItem['title'].toString()),
                subtitle: Text(currentItem['subtitle'].toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    //Editbutton
                    IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _showForm(context, currentItem['key'])),

                    // Delete button
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteItem(currentItem['key'])),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null);
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}

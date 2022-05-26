import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<Products>(context); // disabled to avoid infinite loop
    /**
     * Infinite loop explanation
     * 
     * 1. Flutter triggers build 
     * 2. builds [FutureBuilder] 
     * 3. [FutureBuilder] calls [_refreshProducts()]
     * 4. [_refreshProducts()] calls [.fetchAndSetProducts]
     * 5. [notifyListener()] in .fetchAndSetProducts notifies [Provider.of<Products>(context)]
     * 6. [Provider.of<Products>(context)] triggers build relative to [context] <-- disabled this
     * 7. Go to 2.
     */

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (_, products, __) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                products.items[index].id,
                                products.items[index].title,
                                products.items[index].imageUrl,
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}

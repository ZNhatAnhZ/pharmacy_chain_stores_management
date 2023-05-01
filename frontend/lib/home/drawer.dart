import 'package:flutter/material.dart';
import 'package:medical_chain_manangement/blocks/auth_block.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    AuthBlock auth = Provider.of<AuthBlock>(context);
    return Column(
      children: <Widget>[
        if (auth.isLoggedIn)
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/avatar.png'),
            ),
            accountEmail: Text(auth.employee['employee_email']),
            accountName: Text(auth.employee['employee_name']),
          ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              if (auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.home,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Tổng quan'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'manager' ||
                      auth.employee['role'] == 'store_owner' ||
                      auth.employee['role'] == 'employee'))
                ListTile(
                  leading: Icon(Icons.category,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Hàng hóa'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/inventory_page');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'store_owner' ||
                      auth.employee['role'] == 'employee'))
                ListTile(
                  leading: Icon(Icons.shopping_cart,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Nhập hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/import_inventory_detail');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'store_owner' ||
                      auth.employee['role'] == 'employee'))
                ListTile(
                  leading: Icon(Icons.shopping_basket,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Bán hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/selling_drug');
                  },
                ),
              if (auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.arrow_back_rounded,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Giao dịch vào'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/transaction_in');
                  },
                ),
              if (auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.arrow_forward_rounded,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Giao dịch ra'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/transaction_out');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'manager' ||
                      auth.employee['role'] == 'store_owner'))
                ListTile(
                  leading: Icon(Icons.attach_money,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Sổ quỹ'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/ledger');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'manager' ||
                      auth.employee['role'] == 'store_owner'))
                ListTile(
                  leading: Icon(Icons.assignment_ind,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Đối tác'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/partner');
                  },
                ),
              if (auth.isLoggedIn && auth.employee['role'] == 'manager')
                ListTile(
                  leading: Icon(Icons.store,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Cửa hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/store');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'manager' ||
                      auth.employee['role'] == 'store_owner'))
                ListTile(
                  leading: Icon(Icons.emoji_people,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Nhân viên'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/employee_page');
                  },
                ),
              Divider(),
              if (!auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.lock,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Đăng nhập'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/auth');
                  },
                ),
              if (auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.settings,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Sửa thông tin tài khoản'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              if (auth.isLoggedIn)
                ListTile(
                  leading: Icon(Icons.exit_to_app,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Đăng xuất'),
                  onTap: () async {
                    await auth.logout();
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/');
                  },
                ),
            ],
          ),
        )
      ],
    );
  }
}

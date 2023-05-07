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
        if (auth.isLoggedIn && auth.employee['role'] == 'customer')
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://i.ibb.co/0rDBY9T/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://i.ibb.co/SwfM809/avatar.png'),
            ),
            accountEmail: Text(auth.employee['customer_email']),
            accountName: Text(auth.employee['customer_name']),
          ),
        if (auth.isLoggedIn && auth.employee['role'] == 'admin')
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://i.ibb.co/0rDBY9T/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://i.ibb.co/SwfM809/avatar.png'),
            ),
            accountEmail: Text(auth.employee['admin_email']),
            accountName: Text(auth.employee['admin_name']),
          ),
        if (auth.isLoggedIn &&
            auth.employee['role'] != 'customer' &&
            auth.employee['role'] != 'admin')
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage('https://i.ibb.co/0rDBY9T/drawer-header.jpg'),
            )),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://i.ibb.co/SwfM809/avatar.png'),
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
                    Navigator.pushNamed(context, '/');
                  },
                ),
              if (auth.isLoggedIn && (auth.employee['role'] != 'admin'))
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
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'store_owner' ||
                      auth.employee['role'] == 'employee' ||
                      auth.employee['role'] == 'manager'))
                ListTile(
                  leading: Icon(Icons.arrow_back_rounded,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Giao dịch vào'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/transaction_in');
                  },
                ),
              if (auth.isLoggedIn && (auth.employee['role'] != 'admin'))
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
                      auth.employee['role'] == 'store_owner' ||
                      auth.employee['role'] == 'admin')
                    )
                ListTile(
                  leading: Icon(Icons.emoji_people,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Nhân viên'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/employee_page');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] != 'customer'))
                ListTile(
                  leading: Icon(Icons.accessibility_new_sharp,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Khách hàng'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/customer_page');
                  },
                ),
              if (auth.isLoggedIn &&
                  (auth.employee['role'] == 'manager' ||
                      auth.employee['role'] == 'store_owner'))
                ListTile(
                  leading: Icon(Icons.pie_chart,
                      color: Theme.of(context).colorScheme.secondary),
                  title: Text('Biểu đồ'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/chart_page');
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
                    Navigator.pushNamed(context, '/login');
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

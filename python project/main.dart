import 'package:flutter/material.dart';

void main() {
  runApp(const HungerXApp());
}

class HungerXApp extends StatelessWidget {
  const HungerXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HungerX',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginPage(),
    );
  }
}

/* ---------------- LOGIN PAGE ---------------- */

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fastfood, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text("HungerX",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            TextField(decoration: InputDecoration(labelText: "Email")),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainPage()));
              },
              child: const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}

/* ---------------- MAIN PAGE WITH BOTTOM NAV ---------------- */

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = 0;

  final List<Map<String, dynamic>> cart = [];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(cart: cart, onAdd: () => setState(() {})),
      CartPage(cart: cart),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

/* ---------------- HOME PAGE ---------------- */

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback onAdd;

  const HomePage({super.key, required this.cart, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final foods = [
      {"name": "Burger", "price": 120},
      {"name": "Pizza", "price": 250},
      {"name": "Biryani", "price": 180},
      {"name": "Sandwich", "price": 90},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("HungerX")),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (context, i) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.fastfood, color: Colors.red),
              title: Text(foods[i]["name"]),
              subtitle: Text("₹${foods[i]["price"]}"),
              trailing: ElevatedButton(
                onPressed: () {
                  cart.add(foods[i]);
                  onAdd();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${foods[i]["name"]} added to cart")),
                  );
                },
                child: const Text("Add"),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- CART PAGE ---------------- */

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  const CartPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    int total = cart.fold(0, (sum, item) => sum + item["price"] as int);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(cart[i]["name"]),
                        trailing: Text("₹${cart[i]["price"]}"),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Total: ₹$total",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
    );
  }
}

/* ---------------- PROFILE PAGE ---------------- */

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(
        child: Text(
          "User Profile\nHungerX App",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

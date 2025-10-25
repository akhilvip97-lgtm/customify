import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Using an accent color for a modern feel
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
            .copyWith(secondary: Colors.deepOrangeAccent),
        scaffoldBackgroundColor: Colors.white, // Modern clean background
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ------------------- SPLASH SCREEN -------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Modified to check if 'loggedIn' is true, otherwise go to WelcomePage
  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool('loggedIn') ?? false;
    await Future.delayed(const Duration(milliseconds: 1500)); // Shorter delay

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => loggedIn ? const HomePage() : const WelcomePage(), // Navigate to WelcomePage
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Customify",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.blue),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}

// ------------------- NEW WELCOME PAGE -------------------
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Spacer(flex: 2),
            const Text(
              "Customify",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Design Your Dreams.\nYour personalized product creator.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(flex: 1),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              child: const Text("Log In", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: Colors.blue, width: 2),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SignupPage()));
              },
              child: const Text("Create Account",
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// ------------------- LOGIN PAGE -------------------
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  void _login() async {
    // In a real app, you would validate credentials here
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } else {
      // Simple error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter email and password.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log In")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800),
              ),
              const SizedBox(height: 30),
              TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Email", Icons.email)),
              const SizedBox(height: 15),
              TextField(
                  controller: password,
                  obscureText: true,
                  decoration: _inputDecoration("Password", Icons.lock)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Login",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignupPage()));
                  },
                  child: const Text("Don't have an account? Sign Up")),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}

// ------------------- SIGNUP PAGE -------------------
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  void _signup() async {
    // In a real app, you would create the user here
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('loggedIn', true);
      // Optionally save user name or details
      await prefs.setString('userName', name.text);
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Join Customify!",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800),
              ),
              const SizedBox(height: 30),
              TextField(
                  controller: name,
                  decoration: _inputDecoration("Name", Icons.person)),
              const SizedBox(height: 15),
              TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Email", Icons.email)),
              const SizedBox(height: 15),
              TextField(
                  controller: password,
                  obscureText: true,
                  decoration: _inputDecoration("Password", Icons.lock)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _signup,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Sign Up",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginPage()));
                  },
                  child: const Text("Already have an account? Log In")),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
    );
  }
}

// ------------------- HOME PAGE (DASHBOARD) -------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> products = const [
    {
      "name": "T-Shirt",
      "image":
          "https://i.pinimg.com/236x/a1/7e/23/a17e23192907c8bfed8d6cb6923107e0.jpg"
    },
    {
      "name": "Cap",
      "image":
          "https://assets.myntassets.com/dpr_1.5,q_30,w_400,c_limit,fl_progressive/assets/images/2025/JULY/24/F2znjKKc_6a79d5d68a564c518a2cdf0307d71b85.jpg"
    },
    {
      "name": "Mug",
      "image":
          "https://media.canva.com/v2/mockup-template-rasterize/image0:s3%3A%2F%2Ftemplate.canva.com%2FEAF0EhQ-Xmk%2F2%2F0%2F1600w-BeGW-RfhW20.jpg/mockuptemplateid:FBI9l2tkq/size:L?csig=AAAAAAAAAAAAAAAAAAAAAI6hB1AmRoJNFFwweSbzDSBhBD9R6Nc8gmyXwn-hWmsg&exp=1760239775&osig=AAAAAAAAAAAAAAAAAAAAAJJaGS77nxy3HmphYRfwTHhFvhOx6TQB1TjUiT41i6rL&seoslug=green-and-white-cute-playful-positive-vibes-only-mug&signer=marketplace-rpc"
    },
    {
      "name": "Hoodie",
      "image": "https://peplosjeans.in/cdn/shop/files/985A0983.jpg?v=1735017703"
    },
    {
      "name": "Phone Case",
      "image":
          "https://i.ebayimg.com/images/g/rYwAAOSw6mJe~dO-/s-l1600.jpg"
    },
    {
      "name": "Canvas",
      "image":
          "https://img.joomcdn.net/4c552084b423f03b22b28c89c7c4b786f1e2f7b8_original.jpeg"
    },
  ];

  String userName = "User";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    // Default to "User" if name not found
    setState(() {
      userName = prefs.getString('userName') ?? "Customizer";
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    // Optionally clear other user data
    await prefs.remove('userName');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const WelcomePage()), // Navigate to WelcomePage
        (Route<dynamic> route) => false, // Remove all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customify Store"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const CartPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.deepOrangeAccent),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $userName! 👋",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "What would you like to design today?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Featured Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(height: 25),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Adjusted for better card height
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
                childCount: products.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

// Helper Widget for modern product card
class ProductCard extends StatelessWidget {
  final Map<String, String> product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    product["image"]!,
                    fit: BoxFit.contain,
                    height: 100, // Explicit height helps sometimes
                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                product["name"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Customize",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- PRODUCT DETAIL PAGE -------------------
class ProductDetailPage extends StatelessWidget {
  final Map<String, String> product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product["name"]!)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Image.network(product["image"]!, height: 200, fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 150)),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Unleash your creativity on this ${product["name"]}.",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                "Add your text, logo, or artwork in the designer.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DesignerPage(product: product)));
                },
                icon: const Icon(Icons.design_services, color: Colors.white),
                label: const Text("Start Designing",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- DESIGNER PAGE -------------------
class DesignerPage extends StatefulWidget {
  final Map<String, String> product;
  const DesignerPage({super.key, required this.product});

  @override
  State<DesignerPage> createState() => _DesignerPageState();
}

class _DesignerPageState extends State<DesignerPage> {
  final customTextController = TextEditingController();

  void _addToCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cart') ?? [];

    final item = jsonEncode({
      "name": widget.product["name"],
      "image": widget.product["image"],
      // Use text only if it's not empty, otherwise don't include it or use a default like "No Customization"
      "customText": customTextController.text.trim().isEmpty
          ? "No Customization"
          : customTextController.text.trim(),
    });

    cartData.add(item);
    await prefs.setStringList('cart', cartData);

    if (mounted) {
      // Show confirmation before navigating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${widget.product["name"]} added to cart!"),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      // Wait a moment before navigating
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const CartPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Design ${widget.product["name"]}")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(widget.product["image"]!, height: 200, fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 150)),
                  ),
                  // Simple text overlay to simulate customization
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(
                      customTextController.text.isEmpty
                          ? "Preview Text"
                          : customTextController.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red, // A contrasting color for preview
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: customTextController,
                onChanged: (value) => setState(() {}), // Update preview on change
                decoration: const InputDecoration(
                  labelText: "Enter custom text/logo description",
                  hintText: "E.g., 'My Cool Logo' or 'Est. 2024'",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: Icon(Icons.text_fields),
                ),
                maxLength: 50,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text("Add to Cart",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------- CART PAGE -------------------
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() async {
    setState(() => isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getStringList('cart') ?? [];
    setState(() {
      cartItems =
          cartData.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      isLoading = false;
    });
  }

  void _removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Show confirmation before removal
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${cartItems[index]['name']} removed from cart."),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 1),
      ),
    );
    
    cartItems.removeAt(index);
    final cartData = cartItems.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('cart', cartData);
    setState(() {});
  }

  void _clearCart() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Clear Cart?"),
          content:
              const Text("Are you sure you want to remove all items from your cart?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('cart');
                setState(() {
                  cartItems.clear();
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Cart cleared!"),
                        backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
              onPressed: _clearCart,
              tooltip: "Clear Cart",
            )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey),
                      const SizedBox(height: 10),
                      Text("Your cart is empty.",
                          style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate back to the Home Page
                          Navigator.popUntil(
                              context, (route) => route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()));
                        },
                        icon: const Icon(Icons.store, color: Colors.white),
                        label: const Text("Go Shopping",
                            style: TextStyle(fontSize: 16, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(item["image"],
                              width: 60, height: 60, fit: BoxFit.cover,
                               errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, size: 40)),
                              ),
                        ),
                        title: Text(item["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Customization: ${item["customText"]}",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeItem(index),
                          tooltip: "Remove Item",
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Checkout logic goes here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Proceeding to Checkout! (Demo)"),
                        backgroundColor: Colors.green),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text("Checkout (1 Item)",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            )
          : null,
    );
  }
}
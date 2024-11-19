import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool showForm = false; 
  String _orderType = "Buy"; 
  String _coinName = "ETH";
  double _conversionRate = 37100.0; 
  double _quantity = 0.0;
  final _quantityController = TextEditingController();
  List<Map<String, String>> buyOrders = [

     {"price": "37105.0", "quantity": "32.140"},
            {"price": "37104.2", "quantity": "33.650"},
            {"price": "37103.5", "quantity": "16.880"},
  ];
  List<Map<String, String>> sellOrders = [
        {"price": "37107.9", "quantity": "16.140"},
            {"price": "37108.4", "quantity": "7.780"},
            {"price": "37109.2", "quantity": "17.790"},
  ];


  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          automaticallyImplyLeading: false, 

        title: Text("Order Book",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Toggle button to show/hide form
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showForm = !showForm;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: Text("Buy/Sell"),
              ),
            ),
          ),
          if (showForm) _buildForm(),
          SizedBox(height: 16),
          _buildHeader("Buy Orders"),
          _buildOrderContainer(isBuyOrder: true),
          SizedBox(height: 16),
          _buildHeader("Sell Orders"),
          _buildOrderContainer(isBuyOrder: false),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildHeader("Buy Orders"),
              _buildOrderContainer(isBuyOrder: true),
            ],
          ),
        ),
        VerticalDivider(color: Colors.grey[800], thickness: 1),
        Expanded(
          child: Column(
            children: [
              _buildHeader("Sell Orders"),
              _buildOrderContainer(isBuyOrder: false),
            ],
          ),
        ),
        VerticalDivider(color: Colors.grey[800], thickness: 1),
        // Form always visible on desktop
        Expanded(
          flex: 1,
          child: _buildForm(),
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: title == "Buy Orders" ? Colors.green : Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrderContainer({required bool isBuyOrder}) {
    final orders = isBuyOrder ? buyOrders : sellOrders;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Price & Quantity Header Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  "Price (USDT)",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Quantity (ETH)",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Divider(color: Colors.grey[800]),
        // Order Rows
        Container(
          color: Colors.black,
          height: 200, // Set height for scrollable ListView
          child: ListView.separated(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: orders.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[800]),
            itemBuilder: (context, index) {
              final order = orders[index];
              final color = isBuyOrder ? Colors.green : Colors.red;
              return _buildOrderRow(order["price"]!, order["quantity"]!, color);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderRow(String price, String quantity, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              price,
              style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              quantity,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Place Order",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          // Order Type Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                dropdownColor: Colors.grey[800],
                value: _orderType,
                items: ["Buy", "Sell"]
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type, style: TextStyle(color: Colors.white)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _orderType = value!;
                  });
                },
              ),
              Text(
                _orderType,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Quantity Input
          TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Quantity ($_coinName)",
              labelStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            onChanged: (value) {
              setState(() {
                _quantity = double.tryParse(value) ?? 0.0;
              });
            },
          ),
          SizedBox(height: 8),
          // Conversion Rate Calculation (Price for ETH)
          Text(
            "Price per $_coinName: \$${_conversionRate.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            "Total: \$${(_conversionRate * _quantity).toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          SizedBox(height: 16),
          // Submit Order Button
          ElevatedButton(
            onPressed: _quantity > 0 ? _submitOrder : (){},
            style: ElevatedButton.styleFrom(
              backgroundColor: _orderType == "Buy" ? Colors.green : Colors.red,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: Text(
              "Submit $_orderType Order",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _submitOrder() {
    if (_quantity > 0) {
      // Add the order to the appropriate list
      final order = {
        "price": (_conversionRate * _quantity).toStringAsFixed(2), // Dynamically calculate price
        "quantity": _quantity.toString(),
      };

      setState(() {
        if (_orderType == "Buy") {
          buyOrders.add(order);
        } else {
          sellOrders.add(order);
        }
      });

      // Clear the input fields
      _quantityController.clear();
      _quantity = 0;
    }
  }
}




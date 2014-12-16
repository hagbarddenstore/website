+++
date = "2014-12-12T14:21:00+02:00"
draft = false
title = "Designing entities and storing them in PostgreSQL"
slug = "designing-entities-and-storing-them-in-postgresql"
tags = [ ".net", "postgresql", "object-oriented design", "database design", "npgsql", "csharp", ]
+++

### Prerequisites

1. Basic knowledge of C# and programming
2. Visual Studio 2010 or higher
3. Basic knowledge of PostgreSQL and SQL
4. A PostgreSQL server installed on localhost

### Project setup

1. Create a new Console project in Visual Studio
2. Install the packages npgsql and dapper in the NuGet package manager

### Object structure

First we create the object structure we are going to use. It consists of three
classes. The **Product** and **Order** classes is our entities and the
**OrderRow** class is our value object.

The **Order** class is identified by a
[GUID](https://en.wikipedia.org/wiki/Globally_unique_identifier) and has many
**OrderRow** in the rows collection.

An **OrderRow** is how we add multiple **Products** to a given **Order**.

The **Product** class is also identified by a
[GUID](https://en.wikipedia.org/wiki/Globally_unique_identifier) and has a
unique **Name** and a **Price**.

    public class Product
    {
        public Product(string name, int price)
        {
            Id = Guid.NewGuid();
            Name = name;
            Price = price;
        }

        public Product()
        {
        }

        public Guid Id { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
    }

    public class Order
    {
        public Order(OrderRow[] rows)
        {
            Id = Guid.NewGuid();
            Rows = rows;
        }

        public Order()
        {
        }

        public Guid Id { get; set; }
        public OrderRow[] Rows { get; set; }
    }

    public class OrderRow
    {
        public OrderRow(Product product, int amount)
        {
            ProductId = product.Id;
            Amount = amount;
        }

        public OrderRow()
        {
        }

        public Guid ProductId { get; set; }
        public int Amount { get; set; }
    }

Second, we create the database structure in PostgreSQL. We need three tables,
one **products** table to store the **Product** class, one **orders** table
to store the **Order** class and finally a table to store the **OrderRows**.

Since the **OrderRow** doesn't have an identifier, it will rely on the parent
**Order** and the **Product** it contains to act as the primary key.

### Database structure

    CREATE TABLE "products" (
        "id" UUID NOT NULL,
        "name" VARCHAR(100) NOT NULL,
        "price" INTEGER NOT NULL,
        PRIMARY KEY ("id")
    );

    CREATE UNIQUE INDEX ON "products" ("name");

    CREATE TABLE "orders" (
        "id" UUID NOT NULL,
        PRIMARY KEY ("id")
    );

    CREATE TABLE "orderrows" (
        "orderid" UUID NOT NULL,
        "productid" UUID NOT NULL,
        "amount" INTEGER NOT NULL,
        PRIMARY KEY ("orderid", "productid")
    );

    ALTER TABLE "orderrows" ADD FOREIGN KEY ("orderid") REFERENCES "orders" ("id");
    ALTER TABLE "orderrows" ADD FOREIGN KEY ("productid") REFERENCES "products" ("id");

### Repositories

To fetch the **Orders** and **Products** we need to create a repository per
entity.

    public class ProductsRepository
    {
        private readonly string _connectionString;

        public ProductsRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public void Save(Product product)
        {
            const string Sql = @"
    INSERT INTO products
    (
        id,
        name,
        price
    )
    VALUES
    (
        @Id,
        @Name,
        @Price
    )
    ";

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                connection.Execute(Sql, product);
            }
        }

        public Product FindOne(Guid id)
        {
            const string Sql = @"
    SELECT id,
           name,
           price
    FROM products
    WHERE id = @Id
    ";

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                var product = connection.Query<Product>(Sql, new { Id = id }).First();

                return product;
            }
        }
    }

    public class OrdersRepository
    {
        private readonly string _connectionString;

        public OrdersRepository(string connectionString)
        {
            _connectionString = connectionString;
        }

        public void Save(Order order)
        {
            const string Sql = @"
    INSERT INTO orders
    (
        id
    )
    VALUES
    (
        @Id
    )
    ";

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                connection.Execute(Sql, order);
            }

            SaveRows(order);
        }

        public Order FindOne(Guid id)
        {
            const string Sql = @"
    SELECT id,
           orderid,
           productid,
           amount
    FROM orders
    LEFT JOIN orderrows ON id = orderid
    WHERE id = @Id
    ";

            Func<Order, OrderRow, Order> map = (o, r) =>
            {
                var rows = o.Rows ?? new OrderRow[0];

                rows = rows.Concat(new[] { r }).ToArray();

                o.Rows = rows;

                return o;
            };

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                var order = connection.Query(Sql, map, new { Id = id }, splitOn: "orderid").First();

                return order;
            }
        }

        private void SaveRows(Order order)
        {
            const string Sql = @"
    INSERT INTO orderrows
    (
        orderid,
        productid,
        amount
    )
    VALUES
    (
        @OrderId,
        @ProductId,
        @Amount
    )";

            using (var connection = new NpgsqlConnection(_connectionString))
            {
                foreach (var row in order.Rows)
                {
                    var dto = new
                    {
                        OrderId = order.Id,
                        ProductId = row.ProductId,
                        Amount = row.Amount
                    };

                    connection.Execute(Sql, dto);
                }
            }
        }
    }

### Saving data

    // 1. Connection string
    var connectionString = "Server=127.0.0.1;Database=test;User Id=postgres;Password=;";

    // 2. Create product
    var product = new Product("SMS Sweden" + Guid.NewGuid().ToString().Substring(6), 100);

    // 3. Save product
    var productsRepository = new ProductsRepository(connectionString);

    productsRepository.Save(product);

    // 4. Create order
    var rows = new[]
    {
        new OrderRow(product, 2)
    };

    var order = new Order(rows);

    // 5. Save order
    var ordersRepository = new OrdersRepository(connectionString);

    ordersRepository.Save(order);

#### 1. Connection string

Setup the connection string to your local PostgreSQL database.

#### 2. Create product

Create the new **Product** and initialize it with values.

#### 3. Save product

Create a new **ProductsRepository** instance to save the created **Product**.

#### 4. Create order

Create a new **OrderRow** with the **Product** and create an **Order** with the
**OrderRow** we just created.

#### 5. Save order

Create a new **OrdersRepository** instance to save the created **Order**.

### Reading data

    // 1. Connection string
    var connectionString = "Server=127.0.0.1;Database=test;User Id=postgres;Password=;";

    // 2. Find order
    var ordersRepository = new OrdersRepository(connectionString);

    var id = Guid.Parse("342a28c3-e717-4be3-a8d4-cb5f0009a5af");

    var order = ordersRepository.FindOne(id);

    // 3. Calculate total order value
    var productsRepository = new ProductsRepository(connectionString);

    var total = 0.0;

    foreach (var row in order.Rows)
    {
        var product = productsRepository.FindOne(row.ProductId);

        total += row.Amount * product.Price;
    }

    Console.WriteLine("Order {0} is worth {1} monies!", order.Id, total);

#### 1. Connection string

Setup the connection string to your local PostgreSQL database.

#### 2. Find order

Create the **OrdersRepository** and find the order created earlier.

#### 3. Calculate total order value

Loop through the rows and find the **Product** for each row and calculate
the price for each row and increase the total.

### Questions?

If you have any questions, don't hesitate to send me a tweet at
[@hagbarddenstore](https://twitter.com/hagbarddenstore).

You can find the complete code example at
[this gist](https://gist.github.com/hagbarddenstore/1502313e32d4e6b1d49a).
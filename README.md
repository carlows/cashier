# Cashier

Versions:

elixir 1.14.5, erlang 26.0.1

### High level design

Our cashier is going to be splitted into these modules:

- Cashier: the main application module which orchestrates the full checkout process. Here we will have our integration tests.
- Cart: the cart state will be stored under a genserver (for simplicity, no database is being introduced).
- Products: the products list will be stored under a genserver (for simplicity, no database is being introduced).
- DiscountsConfig: provides access to the business rules for discounts.
- Checkout: is responsible for figuring out which discounts to apply to a given product and return the final prices.
- Discount: multiple smaller discount modules which implement the business rules of how to do some calculation.
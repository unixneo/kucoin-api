# Kucoin API

This is an unofficial Ruby wrapper for the Kucoin exchange REST and WebSocket APIs.

##### Notice

* This is Alpha software.  All issues should be aggressively reported for quick resolution!
* RESTful interface is fully implemented.
* Websocket is fully implemented.
* Pull Requests are very welcome!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kucoin-api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kucoin-api

## Features

#### Current

* Basic implementation of REST API
  * Easy to use authentication
  * Methods return parsed JSON
  * No need to generate timestamps
  * No need to generate signatures

* Basic implementation of WebSocket API
  * Pass procs or lambdas to event handlers
  * Single streams supported
  * Runs on EventMachine

* Exception handling with responses
* High level abstraction

#### TODO

* Websockets currently uses the first InstanceServer returned in the usercenter/loginUser RESTful call. It is currently not clear what Kucoin intends with InstanceServers vs. HistoryServers nor with userType being either "normal" or "vip", so until a use-case arises or feature/bug request comes along that sheds some light on how to select and use specific servers, the websocket interface is hard-wired to the first instance server returned.

## Getting Started

#### REST Client

Require Kucoin API:

```ruby
require 'kucoin-api'
```

Create a new instance of the REST Client:

```ruby
# If you only plan on touching public API endpoints, you can forgo any arguments
client = Kucoin::Api::REST.new

# Otherwise provide an api_key as keyword arguments
client = Kucoin::Api::REST.new api_key: 'your.api_key', api_secret: 'your.api_secret', api_passphrase: 'your.api_passphrase'

# You can provide a sandbox as argument to change Sandbox environment 
client = Kucoin::Api::REST.new sandbox: true 
```

|**Environment**        |**BaseUri**                            |
|:---------------------:|:-------------------------------------:|
| Production `DEFAULT`  | https://openapi-v2.kucoin.com         |
| Sandbox               | https://openapi-sandbox.kucoin.com    |

ALTERNATIVELY, set your API key in exported environment variable:

```bash
export KUCOIN_API_KEY=your.api_key
export KUCOIN_API_SECRET=your.api_secret
export KUCOIN_API_PASSPHRASE=your.api_passphrase
```

Then you can instantiate client without parameters as in first variation above.

Create various requests:

```ruby
# Others / Time / Server Time
client.other.timestamp
  # => 1554213599244

# Currencies Plugin / List exchange rate of coins
client.currency.all
  # => {"rates"=>{"TRAC"=>{"CHF"=>0.02, "HRK"=>0.14...}}

# Public Market Data / Tick
client.market.tick(symbol: 'KCS-BTC')
  # => {"coinType"=>"KCS", "trading"=>true, "symbol"=>"KCS-BTC", "lastDealPrice"=>0.00016493,
  #     "buy"=>0.00016493, "sell"=>0.00016697, "change"=>2.41e-06, "coinTypePair"=>"BTC", "sort"=>0,
  #     "feeRate"=>0.001, "volValue"=>19.92555026, "high"=>0.00016888, "datetime"=>1546427934000,
  #     "vol"=>120465.9024, "low"=>0.000161, "changeRate"=>0.0148
  #   }


# Trading / Create an order
client.order.create 'KCS-BTC', type: 'BUY', price: 0.000127, amount: 22
  # => { "orderOid": "596186ad07015679730ffa02" }


# Assets Operation / Get coin deposit address
client.account.wallet_address('KCS')
  # => {
  #       "oid": "598aeb627da3355fa3e851ca",
  #       "address": "598aeb627da3355fa3e851ca",
  #       "context": null,
  #       "userOid": "5969ddc96732d54312eb960e",
  #       "coinType": "KCS",
  #       "createdAt": 1502276446000,
  #       "deletedAt": null,
  #       "updatedAt": 1502276446000,
  #       "lastReceivedAt": 1502276446000
  #     }
```

Required and optional parameters, as well as enum values, can currently be found on the [Kucoin Apiary Page](https://kucoinapidocs.docs.apiary.io). Parameters should always be passed to client methods as keyword arguments in snake_case form.  symbol, when a required parameter is simply passed as first parameter for most API calls.

### REST Endpoints

REST endpoints are in order as documented on the Kucoin Apiary page (linked above).  The following lists only the method
names, aliases (if any) and parameters of the methods to access endpoints.  For the most part, method names follow naming
of the endpoint's URL and alias method follows the title/name given in Kucoin API documentation.  There were some deviations
where there would otherwise be name clashes/overloading.

#### Currencies Plugin

----
```ruby
currency.all
```
* required params: none
----
```ruby
currency.update currency
```
* required params: currency


#### Language

----
```ruby
language.all
```
* required params: none
----
```ruby
language.update lang
```
* required params: lang

#### User

----
```ruby
user.info
```
* required params: none

#### Assets Operation

----
```ruby
# Get coin deposit address
account.wallet_address coin
```
* required params: coin
----
```ruby
# Create withdrawal apply
account.withdraw coin, options={}
```
* required params: coin
----
```ruby
# Cancel withdrawal
account.wallet_records coin, options={}
```
* required params: coin, type, status
----
```ruby
# List deposit & withdrawal records
account.wallet_records coin, options={}
```
* required params: coin, type, status
----
```ruby
# Get balance of coin
account.balance coin
```
* required params: coin
----
```ruby
# Get balance by page
account.balances options={}
```
* required params: none

#### Trading

----
```ruby
# Create an order
order.create symbol, options={}
```
* required params: symbol, type, price, amount
----
```ruby
# List active orders
order.active symbol, options={}
```
* required params: symbol
----
```ruby
# List active orders in kv format
order.active_kv symbol, options={}
```
* required params: symbol
----
```ruby
# Cancel orders
order.cancel symbol, options={}
```
* required params: symbol, orderOid, type
----
```ruby
# Cancel all orders
order.cancel_all symbol, options={}
```
* required params: symbol
----
```ruby
# List dealt orders
order.dealt options={}
```
* required params: none
----
```ruby
# List dealt orders(specific symbol)
order.specific_dealt symbol, options={}
```
* required params: symbol
----
```ruby
# List all orders
order.all symbol, options={}
```
* required params: symbol, direction
----
```ruby
# Order details
account.detail symbol, options={}
```
* required params: symbol, type, orderOid

#### Public Market Data

----
```ruby
# Tick(Open)
market.tick options={}
```
* required params: none
----
```ruby
# Order books(Open)
market.orders symbol, options={}
```
* required params: symbol
----
```ruby
# Buy Order Books(Open)
market.buy_orders symbol, options={}
```
* required params: symbol
----
```ruby
# Sell Order Books(Open)
market.sell_orders symbol, options={}
```
* required params: symbol
----
```ruby
# Recently deal orders(Open)
market.recent_deal_orders symbol, options={}
```
* required params: symbol
----
```ruby
# List trading markets(Open)
market.trading
```
* required params: none
----
```ruby
# List trading symbols tick (Open)
market.trading_symbols options={}
```
* required params: none
----
```ruby
# List trendings(Open)
market.trading_coins options={}
```
* required params: none
----
```ruby
# Get kline data(Open)
market.kline symbol, options={}
```
* required params: symbol
----
```ruby
# Get kline config(Open, TradingView Version)
market.chart_config
```
* required params: none
----
```ruby
# Get symbol tick(Open, TradingView Version)
market.chart_symbols symbol
```
* required params: none
----
```ruby
# Get kline data(Open, TradingView Version)
market.chart_history options={}
```
* required params: none
----
```ruby
# Get coin info(Open)
market.coin_info coin
```
* required params: coin
----
```ruby
# List coins(Open)
market.coins
```
* required params: none

#### Market Data For authrozied User

----
```ruby
# List trading symbols tick
market.my_trading_symbols options={}
```
* required params: none
----
```ruby
# Get stick symbols
market.stick_symbols
```
* required params: none
----
```ruby
# Get favourite symbols
market.favourite_symbols
```
* required params: none
----
```ruby
# Add/Remove favourite symbol
market.stick_symbol symbol, options={}
```
* required params: none
----
```ruby
# Add/Remove stick symbol
market.favourite_symbol symbol, options={}
```
* required params: none

#### Other

##### Time

----
```ruby
# Server Time
other.timestamp
```
* required params: none

## WebSocket Client

Create a new instance of the WebSocket Client:

```ruby
client = Kucoin::Api::Websocket.new
```

Subscribe various topics:

```ruby
# Currencies Plugin / List exchange rate of coins
methods = { message: proc { |event| puts event.data } }
client.tick(symbol: 'ETH-BTC', methods: methods)
  # => {"id":"259173795477643264","type":"ack"}
  # => {"data"=>{"coinType"=>"ETH", ...}, "topic"=>"/market/ETH-BTC_TICK", "type"=>"message", "seq"=>32752982312089}
  # => {"data"=>{"coinType"=>"ETH", ...}, "topic"=>"/market/ETH-BTC_TICK", "type"=>"message", "seq"=>32752982458728}
  # => ...
```

All subscription topic method will expect "methods" in argument(As shown above).
It's The Hash which contains the event handler methods to pass to the WebSocket client methods.
Proc is the expected value of each event handler key. Following are list of expected event handler keys.
  - :open    - The Proc called when a stream is opened (optional)
  - :message - The Proc called when a stream receives a message
  - :error   - The Proc called when a stream receives an error (optional)
  - :close   - The Proc called when a stream is closed (optional)

### WebSocket Subscribe Topics

Subscribe topics are in order as documented on the Kucoin Apiary page (linked above).

#### Orderbook level2

```ruby
  client.orderbook symbol: symbol, methods: methods
```
* required params: symbol, methods*

#### History

```ruby
  client.history symbol: symbol, methods: methods
```
* required params: symbol, methods*

#### Tick

```ruby
  client.tick symbol: symbol, methods: methods
```
* required params: symbol, methods*

#### Market

```ruby
  client.market symbol: symbol, methods: methods
```
* required params: symbol, methods*

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mwlang/kucoin-api.

## Inspiration

The inspiration for architectural layout of this gem comes nearly one-for-one from the [Binance gem](https://github.com/craysiii/binance) by craysiii.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

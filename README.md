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

#### Market Data

##### Symbols & Ticker
----

```ruby
# Get Symbols List
markets.all
```
* required params: none

----
```ruby
# Get Ticker
markets.stats symbol
```
* required params: symbol

----
```ruby
# Get All Tickers
markets.tickers.all
```
* required params: none

----
```ruby
# Get 24hr Stats
markets.tickers.inside symbol
```
* required params: symbol

----
```ruby
# Get Market List
markets.symbols.all options={}
```
* required params: none

##### Order Book
----

```ruby
# Get Part Order Book(aggregated)
markets.order_book.part symbol, depth
```
* required params: symbol, depth(20, 100)

----
```ruby
# Get Full Order Book(aggregated)
markets.order_book.full_aggregated symbol
```
* required params: symbol

----
```ruby
# Get Full Order Book(atomic)
markets.order_book.full_atomic symbol
```
* required params: symbol

##### Histories
----

```ruby
# Get Trade Histories
markets.histories.trade symbol
```
* required params: symbol

----
```ruby
# Get Klines
markets.histories.klines symbol, type, options={}
```
* required params: symbol, type

##### Currencies
----

```ruby
# Get Currencies
markets.currencies.all
```
* required params: none

----
```ruby
# Get Currency Detail
markets.currencies.detail currency
```
* required params: currency

----
```ruby
# Get Fiat Price
markets.currencies.fiat options= {}
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

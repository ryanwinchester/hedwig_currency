# Hedwig Currency Conversion Responder

[![Hex.pm](https://img.shields.io/hexpm/v/hedwig_currency.svg)](https://hex.pm/packages/hedwig_currency)
 [![Hex.pm](https://img.shields.io/hexpm/l/hedwig_currency.svg)](https://hex.pm/packages/hedwig_currency)
 [![Hex.pm](https://img.shields.io/hexpm/dt/hedwig_currency.svg)](https://hex.pm/packages/hedwig_currency)
 [![Build Status](https://travis-ci.org/ryanwinchester/hedwig_currency.svg?branch=master)](https://travis-ci.org/ryanwinchester/hedwig_currency)

## Installation

Add to the deps in `mix.exs`

```elixir
def deps do
  [
    {:hedwig_currency, "~> 0.1.0"},
  ]
end
```

Add the responder to your `:responders` list in your bot config, `config/config.exs`

```elixir
config :my_robot, MyApp.MyRobot,
  responders: [
    {Hedwig.Responders.Currency, []},
  ]
```

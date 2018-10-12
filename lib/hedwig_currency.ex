defmodule Hedwig.Responders.Currency do
  @moduledoc """
  Responds to `convert <amount> <currency> into|to <currency>`.
  """

  use Hedwig.Responder
  require Logger

  @currencies [
    "EUR", "USD", "JPY", "BGN", "CZK", "DKK", "GBP", "HUF", "LTL", "PLN", "RON",
    "SEK", "CHF", "NOK", "HRK", "RUB", "TRY", "AUD", "BRL", "CAD", "CNY", "HKD",
    "IDR", "ILS", "INR", "KRW", "MXN", "MYR", "NZD", "PHP", "SGD", "THB", "ZAR",
  ]

  @currency_choices Enum.join(@currencies, "|")

  @usage """
  hedwig convert <amount> <currency> into|to <currency> - converts the amount from one currency to the other
  """
  respond ~r/convert ?([0-9.]+) ?(#{@currency_choices}) (?:into|to)? ?(#{@currency_choices})/i, msg do
    amount = Decimal.new(msg.matches[1])
    from = String.upcase(msg.matches[2])
    to = String.upcase(msg.matches[3])

    converted = convert(amount, fetch_rates(from, to))

    send msg, "#{format_num(amount)} #{from} is #{format_num(converted)} #{to}"
  end

  # Fetch the exchange rates XML
  @spec fetch_rates(String.t, String.t) :: {Decimal.t, Decimal.t} | :error
  defp fetch_rates(from, to) do
    url = "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml"
    headers = [{"User-Agent", "Mozilla/5.0"}]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        {rate_from_xml(from, body), rate_from_xml(to, body)}
      {_, res} ->
        Logger.warn inspect(res)
        :error
    end
  end

  # Get the exchange rate from the XML.
  @spec rate_from_xml(String.t, String.t) :: Decimal.t
  defp rate_from_xml(currency, xml) do
    ~r/currency='#{currency}' rate='(.+)'/
    |> Regex.run(xml, capture: :all_but_first)
    |> Enum.at(0)
    |> Decimal.new()
  end

  # Convert the currency from one to the other.
  @spec convert(Decimal.t, {Decimal.t, Decimal.t}) :: Decimal.t
  defp convert(amount, {from_rate, to_rate}) do
    Decimal.div(amount, from_rate) |> Decimal.mult(to_rate)
  end

  # Format the number to a string with 2 decimal places.
  @spec format_num(Decimal.t) :: String.t
  defp format_num(num) do
    Decimal.round(num, 2) |> Decimal.to_string()
  end
end
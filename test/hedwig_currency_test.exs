defmodule Hedwig.Responders.CurrencyTest do
  use Hedwig.RobotCase

  @tag start_robot: true, name: "alfred", responders: [{Hedwig.Responders.Currency, []}]

  test "responds with currency conversion", %{adapter: adapter, msg: msg} do
    send adapter, {:message, %{msg | text: "alfred convert 10 USD to CAD"}}
    assert_receive {:message, %{text: text}}
    assert String.contains?(text, "10.00 USD is")
  end
end

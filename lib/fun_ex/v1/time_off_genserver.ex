defmodule FunEx.V1.TimeOffGenServer do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_args), do: {:ok, nil}

  def handle_call({:next_holiday, date_string, territory}, _from, state) do
    {:ok, date} = Date.from_iso8601(date_string)
    {:ok, json} = File.read("bank_holidays.json")
    {:ok, data} = Jason.decode(json)

    bank_holidays =
      data
      |> Map.get(territory, %{})
      |> Map.get("events", [])

    result =
      bank_holidays
      |> Enum.find(fn bank_holiday ->
        {:ok, bank_holiday_date} =
          bank_holiday
          |> Map.get("date", "2020-01-01")
          |> Date.from_iso8601()

        Timex.diff(bank_holiday_date, date) >= 0
      end)

    {:reply, result, state}
  end
end

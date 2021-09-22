defmodule FunEx.V2.TimeOffController do
  # use FunEx, :controller

  def next_holiday(conn, %{"date" => date, "territory" => territory}) do
    result = FunEx.V2.TimeOffService.next_holiday(date, territory, &File.read/1)
    # render(conn, "temp.html", result: result)
  end
end

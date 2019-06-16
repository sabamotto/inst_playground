defmodule InstPlaygroundWeb.PlaygroundControllerTest do
  use InstPlaygroundWeb.ConnCase

  describe "index" do
    test "display playground field", %{conn: conn} do
      conn = get(conn, Routes.playground_path(conn, :index))
      assert html_response(conn, 200) =~ "Playground Global Room"
    end
  end
end

defmodule InstPlaygroundWeb.PageController do
  use InstPlaygroundWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule InstPlaygroundWeb.Router do
  use InstPlaygroundWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InstPlaygroundWeb do
    pipe_through :browser
    get "/", Redirector, to: "/rooms/playground"

    scope "/rooms" do
      get "/", Redirector, to: "/rooms/playground"

      resources "/playground", PlaygroundController, only: [:index]
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", InstPlaygroundWeb do
  #   pipe_through :api
  # end
end

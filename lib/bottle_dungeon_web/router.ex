defmodule BottleDungeonWeb.Router do
  use BottleDungeonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BottleDungeonWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BottleDungeonWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/", PageController, :index
  end

  scope "/manage", BottleDungeonWeb do
    pipe_through [:browser, :authenticate_user]

    resources "/games", GameSessionController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BottleDungeonWeb do
  #   pipe_through :api
  # end
end

defmodule MercuryWeb.Router do
  use MercuryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MercuryWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MercuryWeb.AuthSession
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MercuryWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth/google/callback", GoogleAuthController, :index
    get "/logout", PageController, :delete

    live "/batches", BatchLive.Index, :index
    live "/batches/:id", BatchLive.Index, :index
    live "/duplicate/:dupe", BatchLive.Index, :index

    resources "/list", BatchController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", MercuryWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MercuryWeb.Telemetry
    end
  end
end

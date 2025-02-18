defmodule BernWeb.Router do
  use BernWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BernWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :robots do
    plug :accepts, ~w[json txt xml webmanifest]
  end

  scope "/", BernWeb, log: false do
    pipe_through [:robots]

    get "/sitemap.xml", RobotController, :sitemap
    get "/robots.txt", RobotController, :robots
    get "/rss.xml", RobotController, :rss
    get "/site.webmanifest", RobotController, :site_webmanifest
    get "/browserconfig.xml", RobotController, :browserconfig
  end

  scope "/", BernWeb do
    pipe_through :browser

    live "/", PageLive, :home
    live "/blog", BlogLive, :index, as: :blog
    live "/blog/:id", BlogLive, :show, as: :blog
    live "/projects", PageLive, :projects
  end

  scope "/admin" do
    pipe_through [:browser, :check_auth]
    live_dashboard "/dashboard", metrics: BernWeb.Telemetry
  end

  def check_auth(conn, _opts) do
    with {user, pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         true <- user == System.get_env("AUTH_USER", "admin"),
         true <- pass == System.get_env("AUTH_PASS", "admin") do
      conn
    else
      _ ->
        conn
        |> Plug.BasicAuth.request_basic_auth()
        |> halt()
    end
  end
end

defmodule MercuryWeb.BatchLive.Index do
  use MercuryWeb, :live_view
  alias Mercury.Table
  alias MercuryWeb.AuthSession

  @impl true
  def mount(_params, session, socket) do
    if AuthSession.logged_in_session?(session) do
      {:ok, assign(socket, account: session["account"], table: %Table{})}
    else
      {:ok, redirect(socket, to: Routes.page_path(socket, :index))}
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("recover", %{"data" => %{"tsv" => tsv_data}}, socket) do
    table = Table.from_tsv(tsv_data)
    {:noreply, assign(socket, :table, table)}
  end

  def handle_event("parse_data", %{"data" => %{"tsv" => tsv_data}}, socket) do
    table = Table.from_tsv(tsv_data)
    {:noreply, assign(socket, :table, table)}
  end
end

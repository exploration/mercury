defmodule MercuryWeb.BatchLive.Index do
  @moduledoc """
  This is basically the application. It runs as a state machine.

  Valid view states are:

  1. `"new"` - No data have been entered - only show the "upload data" dialog.
  2. `"parsed"` - Data have been successfully uploaded and parsed. Data dialog is hidden, form options are shown.
  """

  use MercuryWeb, :live_view
  alias Mercury.Table
  alias MercuryWeb.AuthSession

  @impl true
  def mount(_params, session, socket) do
    if AuthSession.logged_in_session?(session) do
      {:ok, assign(socket, account: session["account"], state: "new", tsv_data: "", table: %Table{})}
    else
      {:ok, redirect(socket, to: Routes.page_path(socket, :index))}
    end
  end

  @impl true
  def handle_event("recover", %{"data" => %{"tsv" => tsv_data}}, socket) do
    table = Table.from_tsv(tsv_data)
    {:noreply, assign(socket, state: "parsed", tsv_data: tsv_data, table: table)}
  end

  def handle_event("parse_data", %{"data" => %{"tsv" => tsv_data}}, socket) do
    table = Table.from_tsv(tsv_data)
    {:noreply, assign(socket, state: "parsed", tsv_data: tsv_data, table: table)}
  end

  def handle_event("set_state", %{"state" => state}, socket) do
    {:noreply, assign(socket, state: state)}
  end
end

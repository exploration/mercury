defmodule MercuryWeb.BatchLive.Index do
  @moduledoc """
  This is basically the application. It runs as a state machine.

  Valid view states are:

  1. `"new"` - No data have been entered - only show the "upload data" dialog.
  2. `"parsed"` - Data have been successfully uploaded and parsed. Data dialog is hidden, form options are shown.
  """

  use MercuryWeb, :live_view
  alias Mercury.{Batch.Batch, Batch.State, Table}
  alias MercuryWeb.AuthSession

  @impl true
  def mount(_params, session, socket) do
    if AuthSession.logged_in_session?(session) do
      state = %State{account: session["account"]}
      {:ok, assign(socket, state: state)}
    else
      {:ok, redirect(socket, to: Routes.page_path(socket, :index))}
    end
  end

  @impl true
  def handle_event("recover", %{"batch" => %{"table_data" => table_data}}, socket) do
    {:noreply, update_table_data(socket, table_data)}
  end

  def handle_event("parse_data", %{"batch" => %{"table_data" => table_data}}, socket) do
    {:noreply, update_table_data(socket, table_data)}
  end

  def handle_event("override_phase", %{"phase" => phase}, socket) do
    state = %{socket.assigns.state | phase: phase}
    {:noreply, assign(socket, state: state)}
  end

  defp assign_phase(state) do
    case state do
      %{batch: %Batch{table_data: ""}} ->
        %{state| phase: "new"}
      _ -> 
        %{state| phase: "parsed"}
    end
  end

  defp update_table_data(socket, table_data) do
    state = %{socket.assigns.state |
      batch: %{socket.assigns.state.batch | table_data: table_data},
      changeset: Batch.changeset(socket.assigns.state.batch, %{table_data: table_data}),
      table: Table.from_tsv(table_data),
    }
    |> assign_phase()
    assign(socket, state: state)
  end
end

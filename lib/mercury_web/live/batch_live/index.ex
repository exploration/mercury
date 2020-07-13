defmodule MercuryWeb.BatchLive.Index do
  @moduledoc """
  This is basically the application. It runs as a state machine. See `MercuryWeb.Batch.State` for more details.
  """

  use MercuryWeb, :live_view
  alias Mercury.{Batch.Batch, Batch.State, Email, Mailer, Table}
  alias MercuryWeb.AuthSession

  @impl true
  def mount(_params, session, socket) do
    if AuthSession.logged_in_session?(session) do
      batch = %Batch{creator: session["account"]}
      state = %State{account: session["account"], batch: batch}
      {:ok, assign(socket, state: state)}
    else
      {:ok, redirect(socket, to: Routes.page_path(socket, :index))}
    end
  end

  @impl true
  def handle_event("decrement_selected_row", _params, socket) do
    state = socket.assigns.state
    cond do
      state.selected_row == 0 ->
        {:noreply, socket}
      true ->
        {:noreply, assign(socket, :state, %{state | selected_row: state.selected_row - 1})}
    end
  end

  def handle_event("increment_selected_row", _params, socket) do
    state = socket.assigns.state
    cond do
      state.selected_row == state.table.row_count - 1 ->
        {:noreply, socket}
      true ->
        {:noreply, assign(socket, :state, %{state | selected_row: state.selected_row + 1})}
    end
  end

  def handle_event("override_phase", %{"phase" => phase}, socket) do
    state = %{socket.assigns.state | phase: phase}
    {:noreply, assign(socket, state: state)}
  end
  
  def handle_event("parse_data", %{"batch" => %{"table_data" => table_data}}, socket) do
    {:noreply, update_table_data(socket, table_data)}
  end

  def handle_event("recover", %{"batch" => %{"table_data" => table_data}}, socket) do
    {:noreply, update_table_data(socket, table_data)}
  end

  def handle_event("select_row", %{"row" => row}, socket) do
    state = socket.assigns.state
    {:noreply, assign(socket, :state, %{state | selected_row: String.to_integer(row)})}
  end

  def handle_event("send_batch", %{"batch" => params}, socket) do
    changeset = 
      Batch.change(socket.assigns.state.batch, params) 
      |> Batch.validate()
    socket = 
      if changeset.valid? do
        Process.send_after(self(), :send_emails, 1)
        assign(socket, :state, %{socket.assigns.state | updating: true})
      end
    {:noreply, assign(socket, :state, %{socket.assigns.state | changeset: changeset})}
  end

  def handle_event("validate_batch", %{"batch" => params}, socket) do
    state = %{socket.assigns.state |
      changeset: 
        Batch.change(socket.assigns.state.batch, params) 
        |> Batch.validate()
    }
    {:noreply, assign(socket, :state, state)}
  end

  @impl true
  def handle_info(:send_emails, socket) do
    {batch, changeset} = send_emails(socket)
    {:noreply, assign(socket, :state, %{socket.assigns.state |
      changeset: changeset, batch: batch, updating: false
    })}
  end

  @doc false
  def send_emails(socket) do
    state = socket.assigns.state
    send_report = Enum.map(Enum.with_index(state.table.rows), fn {_row, index} ->
      {_, {status, email}} = 
        Email.email(%{state | selected_row: index})
        |> Mailer.deliver_now(response: true)
      %{email: email, status: status}
    end)

    changeset = 
      state.changeset
      |> Ecto.Changeset.change(send_report: send_report)
      |> Batch.validate()
    
    {:ok, batch} = Mercury.Repo.insert(changeset)

    {batch, changeset}
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
      table: Table.from_tsv(table_data),
    }
    |> assign_phase()
    assign(socket, state: state)
  end
end

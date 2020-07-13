defmodule MercuryWeb.BatchLive.Index do
  @moduledoc """
  This is basically the application. It runs as a state machine. See `MercuryWeb.Batch.State` for more details.
  """

  use MercuryWeb, :live_view
  alias Mercury.{Batch.Batch, Batch.Report, Batch.State, Email, Mailer, Table}
  alias MercuryWeb.AuthSession

  @impl true
  def mount(params, session, socket) do
    if AuthSession.logged_in_session?(session) do
      case params do
        %{"id" => id} ->
          batch = Mercury.Batch.get(id)
          {:ok, assign(socket, state: mount_state(session,batch))}
        %{"dupe" => id} ->
          batch = Mercury.Batch.get(id)
          batch = %{batch | id: nil, send_report: []}
          {:ok, assign(socket, state: mount_state(session,batch))}
        _ ->
          batch = %Batch{creator: session["account"]}
          {:ok, assign(socket, state: mount_state(session,batch))}
      end
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
      else
        socket
      end
    {:noreply, assign(socket, :state, %{socket.assigns.state | changeset: changeset})}
  end

  def handle_event("send_one_email", _params, socket) do
    state = socket.assigns.state
    report = 
      send_email(state, state.selected_row)
      |> Jason.encode! |> Jason.decode!
    if State.at_phase(state, "sent") do
      send_report = List.replace_at(state.batch.send_report, state.selected_row, report)
      case Mercury.Batch.update(state.batch, %{send_report: send_report}) do
        {:ok, batch} -> 
          {:noreply, assign(socket, :state, %{state | batch: batch})}

        _ -> 
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
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
    {batch, _changeset} = send_emails(socket)
    {:noreply, push_redirect(socket, to: Routes.batch_index_path(socket, :index, batch.id))}
  end

  @doc false
  def send_emails(socket) do
    state = socket.assigns.state
    send_report = 
      state.table.rows
      |> Enum.with_index()
      |> Enum.map(fn {_row, index} ->
        send_email(state, index)
      end)

    changeset = 
      state.changeset
      |> Ecto.Changeset.change(send_report: send_report)
      |> Batch.validate()

    {:ok, batch} = Mercury.Repo.insert(changeset)

    {batch, changeset}
  end

  defp mount_state(session, batch) do
    changeset = Batch.change(batch, %{})
    %State{account: session["account"], batch: batch, changeset: changeset, table: Table.from_tsv(batch.table_data)}
    |> State.assign_phase()
  end

  defp send_email(state, index) do
    case Mix.env do
      :test ->
        {_, {status, email}} = 
          Email.email(%{state | selected_row: index})
          |> Mailer.deliver_now(response: true)
          Report.new(email, status)
      _ -> 
        email = Email.email(%{state | selected_row: index})
        {_, %{status_code: status}} = try do
          Mailer.deliver_now(email, response: true)
        rescue
          e -> {:error, e}
        end
        Report.new(email, status)
    end
  end

  defp update_table_data(socket, table_data) do
    state = %{socket.assigns.state |
      batch: %{socket.assigns.state.batch | table_data: table_data},
      table: Table.from_tsv(table_data),
    }
    |> State.assign_phase()
    assign(socket, state: state)
  end
end

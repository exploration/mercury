defmodule Mercury.EmailTest do
  use Mercury.DataCase, async: true

  alias Mercury.{Email, Table}

  describe "an email" do
    test "works" do
      state = batch_state()
      Enum.each(Enum.with_index(state.table.rows), fn {_row, index} ->
        email = Email.email(%{state | selected_row: index})
        assert email.to == Table.get_field(state.table, index, "Email")
        assert email.from == {"A Person", "from@from.org"}
        assert email.text_body =~ Table.get_field(state.table, index, "First Name")
      end)
    end
  end

end

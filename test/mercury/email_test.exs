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

    test "filtering HTML" do
      problematic_html = """
      <a href=”https://www.minecraft.net/en-us/download”>Minecraft Java site</a>

      <b>cool</b>
      """
      improved_html = "<a href=\"https://www.minecraft.net/en-us/download\">Minecraft Java site</a><br><br><b>cool</b><br>"
      batch_attrs = %{batch_attrs() | body: problematic_html}
      batch = batch(batch_attrs)
      changeset = Mercury.Batch.Batch.change(%Mercury.Batch.Batch{}, batch_attrs)
      state = batch_state(%{batch: batch, changeset: changeset})
      %{text_body: text_body, private: %{template_content: [%{"content" => content}]}} = Email.email(state)
      assert content == improved_html
      assert text_body == problematic_html
    end
  end

end

defmodule Mercury.TableTest do
  use Mercury.DataCase, async: true
  alias Mercury.{Table, Row}

  @raw_row "donald\tneat"

  test "row parsing" do
    row = Row.from_tsv_row @raw_row
    assert %Row{fields: ["donald", "neat"]} = row
  end

  test "table parsing" do
    table = Table.from_tsv table_data()
    assert %Table{field_count: 3} = table
    assert %Table{header: %Row{fields: ["First Name", "Last Name", "Email"]}} = table
    assert %Table{rows: [%Row{fields: ["Donald", "Merand", "dmerand@explo.org"]}, %Row{fields: ["Eric", "Edwards", "eedwards@explo.org"]}, %Row{fields: ["Sam", "Osborn", "sosborn@explo.org"]}]} = table
  end

  test "data retrieval" do
    table = Table.from_tsv table_data()
    assert "Donald" == Table.get_field(table, 0, "First Name")
    assert "Sam" == Table.get_field(table, 2, "First Name")
    assert "eedwards@explo.org" == Table.get_field(table, 1, "Email")

    assert "" == Table.get_field(table, 100, "First Name")
    assert "" == Table.get_field(table, 0, "Crap Weasel")
  end
end

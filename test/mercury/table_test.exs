defmodule Mercury.TableTest do
  use Mercury.DataCase, async: true
  alias Mercury.{Table, Row}

  @raw_row "donald\tneat"
  @raw_data "First Name\tLast Name\tEmail\nDonald\tMerand\tdmerand@explo.org\nEric\tEdwards\teedwards@explo.org\nSam\tOsborn\tsosborn@explo.org"

  test "row parsing" do
    row = Row.from_tsv_row @raw_row
    assert %Row{fields: ["donald", "neat"]} = row
  end

  test "data parsing" do
    data = Table.from_tsv @raw_data
    assert %Table{field_count: 3} = data
    assert %Table{header: %Row{fields: ["First Name", "Last Name", "Email"]}} = data
    assert %Table{rows: [%Row{fields: ["Donald", "Merand", "dmerand@explo.org"]}, %Row{fields: ["Eric", "Edwards", "eedwards@explo.org"]}, %Row{fields: ["Sam", "Osborn", "sosborn@explo.org"]}]} = data
  end
end

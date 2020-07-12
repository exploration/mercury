defmodule Mercury.BatchStateTest do
  use Mercury.DataCase, async: true
  alias Mercury.Batch.State

  test "state machine" do
    assert State.at_phase(%State{}, "new")
    refute State.at_phase(%State{}, "parsed")

    assert State.up_to_phase(%State{}, "new")
    refute State.up_to_phase(%State{}, "parsed")
    assert State.up_to_phase(%State{phase: "parsed"}, "new")
    assert State.up_to_phase(%State{phase: "parsed"}, "parsed")
  end
end

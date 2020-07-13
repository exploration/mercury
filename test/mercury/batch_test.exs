defmodule Mercury.BatchTest do
  use Mercury.DataCase, async: true
  alias Mercury.Batch

  test "create batch" do
    assert {:ok, batch} = Batch.create(batch_attrs())
  end

  describe "batches" do
    setup [:create_batch]

    test "listing batches" do
      assert Enum.count(Batch.list()) == 1
    end

    test "listing batches by email" do
      Batch.create(%{batch_attrs() | creator: %{account_attrs() | email: "email@email.com"}})
      assert 2 == Enum.count(Batch.list())
      assert 1 == Enum.count(Batch.list(email: "email@email.com"))
    end

    test "update", %{batch: batch} do
      assert {:ok, %Mercury.Batch.Batch{to: "wat"}} = Batch.update(batch, %{to: "wat"})
    end
  end

  defp create_batch(_) do
    {:ok, batch} = Batch.create(batch_attrs())
    {:ok, batch: batch}
  end
end

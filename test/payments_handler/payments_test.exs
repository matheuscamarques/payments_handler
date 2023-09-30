defmodule PaymentsHandler.PaymentsTest do
  use ExUnit.Case, async: false
  alias PaymentsHandler.Db.Engines.Objects.Events
  alias PaymentsHandler.Payments
  #   --
  # # Reset state before starting tests

  # POST /reset

  # 200 OK
  describe "Reset state" do
    test "before starting tests" do
      Payments.reset()

      assert Payments.get_balance_by_id("SYSTEM_EVENT") ==
               {:ok, 100_000_000_000, %{balance: 100_000_000_000}}
    end
  end

  describe "Get balance" do
    test "for non-existing account" do
      Payments.reset()
      {:ok, balance_sys, %{balance: balance_sys}} = Payments.get_balance_by_id("SYSTEM_EVENT")
      assert balance_sys == 100_000_000_000

      assert {:ok, 0, %{balance: 0}} = Payments.get_balance_by_id(100)
    end

    test "existing account" do
      Payments.reset()

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, 10, _} = Payments.get_balance_by_id(100)

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      {:ok, 20, %{balance: 20}} = Payments.get_balance_by_id(100)
    end
  end

  # --
  # # Create account with initial balance

  # POST /event {"type":"deposit", "destination":"100", "amount":10}

  # 201 {"destination": {"id":"100", "balance":10}}
  describe "Create account" do
    test "with initial balance" do
      Payments.reset()

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, 10, _} = Payments.get_balance_by_id(100)
    end
  end

  describe "Deposit into" do
    test "existing account" do
      Payments.reset()

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, 10, %{balance: 10}} = Payments.get_balance_by_id(100)

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, 20, %{balance: 20}} = Payments.get_balance_by_id(100)
    end
  end

  describe "Withdraw" do
    test "from non-existing account" do
      Payments.reset()

      assert Payments.transfer(%Events{
               amount: 10,
               origin: 100,
               destination: "SYSTEM_EVENT",
               type: "withdraw"
             }) == {:error, "Not have amount to transfer"}
    end

    test "from existing account" do
      Payments.reset()

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 5,
                 origin: 100,
                 destination: "SYSTEM_EVENT",
                 type: "withdraw"
               })

      assert {:ok, 15, %{balance: 15}} = Payments.get_balance_by_id(100)
    end
  end

  describe "Transfer" do
    test "from existing account" do
      Payments.reset()

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 10,
                 origin: "SYSTEM_EVENT",
                 destination: 100,
                 type: "deposit"
               })

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 5,
                 origin: 100,
                 destination: "SYSTEM_EVENT",
                 type: "withdraw"
               })

      assert {:ok, _, _} =
               Payments.transfer(%Events{
                 amount: 15,
                 origin: 100,
                 destination: 300,
                 type: "withdraw"
               })

      assert {:ok, 0, _} = Payments.get_balance_by_id(100)
      assert {:ok, 15, _} = Payments.get_balance_by_id(300)
    end

    test "from from non-existing account" do
      Payments.reset()

      assert Payments.transfer(%Events{
               amount: 15,
               origin: 200,
               destination: 300,
               type: "deposit"
             }) == {:error, "Not have amount to transfer"}
    end
  end
end

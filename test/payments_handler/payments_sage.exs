defmodule PaymentsHandler.PaymentsSage do
  use ExUnit.Case, async: false
  alias PaymentsHandler.Payments.Events
  alias PaymentsHandler.Sages.PaymentSage

  #   --
  # # Reset state before starting tests

  # POST /reset

  # 200 OK
  describe "Reset state" do
    test "before starting tests" do
      GenServer.call(EventsServer, :reset)

      assert GenServer.call(EventsServer, {:state, "SYSTEM_EVENT"}) == %{
               balance: 100_000_000_000,
               events: %{
                 deposits: [
                   %PaymentsHandler.Payments.Events{
                     amount: 100_000_000_000,
                     destination: "SYSTEM_EVENT",
                     type: "deposit",
                     origin: "ADMIN"
                   }
                 ],
                 transfers: [],
                 withdraws: []
               },
               id: "SYSTEM_EVENT"
             }
    end
  end

  describe "Get balance" do
    test "for non-existing account" do
      GenServer.call(EventsServer, :reset)
      budget_sys = GenServer.call(EventsServer, {:state, "SYSTEM_EVENT"})
      assert budget_sys.balance == 100_000_000_000

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 0
    end

    test "existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 10

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 20
    end
  end

  # --
  # # Create account with initial balance

  # POST /event {"type":"deposit", "destination":"100", "amount":10}

  # 201 {"destination": {"id":"100", "balance":10}}
  describe "Create account" do
    test "with initial balance" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 10
    end
  end

  describe "Deposit into" do
    test "existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 10

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 20
    end
  end

  describe "Withdraw" do
    test "from non-existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: 100,
               destination: "SYSTEM_EVENT",
               type: "withdraw"
             }) == {:error, "Not have amount to transfer"}
    end

    test "from existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      assert PaymentSage.transfer_sage(%Events{
               amount: 5,
               origin: 100,
               destination: "SYSTEM_EVENT",
               type: "withdraw"
             }) == :ok

      budget = GenServer.call(EventsServer, {:state, 100})
      assert budget.balance == 15
    end
  end

  describe "Transfer" do
    test "from existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      assert PaymentSage.transfer_sage(%Events{
               amount: 10,
               origin: "SYSTEM_EVENT",
               destination: 100,
               type: "deposit"
             }) == :ok

      assert PaymentSage.transfer_sage(%Events{
               amount: 5,
               origin: 100,
               destination: "SYSTEM_EVENT",
               type: "withdraw"
             }) == :ok

      assert PaymentSage.transfer_sage(%Events{
               amount: 15,
               origin: 100,
               destination: 300,
               type: "withdraw"
             }) == :ok

      assert GenServer.call(EventsServer, {:state, 100}).balance == 0
      assert GenServer.call(EventsServer, {:state, 300}).balance == 15
    end

    test "from from non-existing account" do
      GenServer.call(EventsServer, :reset)

      assert PaymentSage.transfer_sage(%Events{
               amount: 15,
               origin: 200,
               destination: 300,
               type: "deposit"
             }) == {:error, "Not have amount to transfer"}
    end
  end
end

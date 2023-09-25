defmodule PaymentsHandler.Db.EventsServer do
  use GenServer

  def start_link(init_args), do:  GenServer.start_link(__MODULE__, [init_args])


  def init(_args) do
    {:ok, %{
      withdraws: [],
      deposits: [],
      transfer: [],
    }}
  end


  def handle_call({:withdraw, payload}, _from, state) do
    {:reply, :ok , state}
  end

  def handle_call({:deposit, payload}, _from, state) do
    {:reply, :ok , state}
  end

  def handle_call({:transfer, payload}, _from, state) do
    {:reply, :ok , state}
  end



end

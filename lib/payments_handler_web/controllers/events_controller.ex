defmodule PaymentsHandlerWeb.EventsController do
  use PaymentsHandlerWeb, :controller

  alias PaymentsHandler.Payments
  alias PaymentsHandler.Payments.Events
  import PaymentsHandlerWeb.EventsJSON

  def reset(conn, _) do
    Payments.reset()

    conn
    |> put_status(200)
    |> text("OK")
  end

  def balance(conn, %{"account_id" => account_id}) do
    balance = Payments.get_balance_by_id(account_id)

    case balance do
      0 ->
        conn
        |> put_status(404)

      _value ->
        conn
        |> put_status(200)
    end
    |> json(balance)
  end

  def post_event(conn, %{
        "type" => "deposit",
        "destination" => destination,
        "amount" => amount
      }) do
    event = %Events{
      origin: "SYSTEM_EVENT",
      destination: destination,
      amount: amount,
      type: "deposit"
    }

    event
    |> Payments.transfer()

    conn
    |> put_status(201)
    |> json(deposit_json(event))
  end

  def post_event(conn, %{
        "type" => "withdraw",
        "origin" => origin,
        "amount" => amount
      }) do
    event = %Events{
      origin: origin,
      destination: "SYSTEM_EVENT",
      amount: amount,
      type: "withdraw"
    }

    event
    |> Payments.transfer()
    |> case do
      {:error, _} ->
        conn |> put_status(404) |> text(0)

      :ok ->
        conn
        |> put_status(201)
        |> json(withdraw_json(event))
    end
  end

  def post_event(conn, %{
        "type" => "transfer",
        "origin" => origin,
        "amount" => amount,
        "destination" => destination
      }) do
    event = %Events{
      origin: origin,
      destination: destination,
      amount: amount,
      type: "transfer"
    }

    event
    |> Payments.transfer()
    |> case do
      {:error, _} ->
        conn |> put_status(404) |> text(0)

      :ok ->
        conn
        |> put_status(201)
        |> json(transfer_json(event))
    end
  end
end

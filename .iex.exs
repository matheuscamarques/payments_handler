alias PaymentsHandler.Payments.Events
alias PaymentsHandler.Sages.PaymentSage
# # Defina o intervalo para IDs aleatórios (por exemplo, de 1 a 1000)
# id_min = 1
# id_max = 10000

# {:ok, server} = {:ok, EventsServer}

# # Loop para gerar 1000 operações randômicas com IDs aleatórios
# Enum.each(1..10000, fn _ ->
#   # Gera um ID aleatório dentro do intervalo especificado
#   random_id = :rand.uniform(id_max - id_min + 1) + id_min - 1
#   random_id_2 = :rand.uniform(id_max - id_min + 1) + id_min - 1
#   # Gera um valor aleatório entre 1 e 1000
#   random_amount = :rand.uniform(1000)
#   # Escolhe aleatoriamente um tipo de operação
#   random_type = Enum.random(["withdraw", "deposit", "transfer"])

#   event = %Events{
#     amount: random_amount,
#     type: random_type,
#     destination:
#       case random_type do
#         "withdraw" -> "SYSTEM_EVENT"
#         "deposit" -> random_id
#         "transfer" -> random_id
#       end,
#     origin:
#       case random_type do
#         "withdraw" -> random_id
#         "deposit" -> "SYSTEM_EVENT"
#         "transfer" -> random_id_2
#       end
#   }

#   PaymentSage.transfer_sage(event)
# end)

# random_1 = :rand.uniform(id_max - id_min + 1) + id_min - 1
# random_2 = :rand.uniform(id_max - id_min + 1) + id_min - 1
# random_3 = :rand.uniform(id_max - id_min + 1) + id_min - 1

# GenServer.call(server, {:state, random_1}) |> IO.inspect()
# GenServer.call(server, {:state, random_2}) |> IO.inspect()
# GenServer.call(server, {:state, random_3}) |> IO.inspect()

# # GenServer.call(server, {:state, "SYSTEM_EVENT"}) |> IO.inspect()

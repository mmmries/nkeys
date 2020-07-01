defmodule NKEYSTest do
  use ExUnit.Case

  test "from_seed" do
    seed = "SUAMLK2ZNL35WSMW37E7UD4VZ7ELPKW7DHC3BWBSD2GCZ7IUQQXZIORRBU"
    nonce = "PXoWU7zWAMt75FY"
    {:ok, keypair} = NKEYS.Keypair.from_seed(seed)
    signed_nonce = NKEYS.sign(keypair, nonce)
    encoded_signed_nonce = Base.encode64(signed_nonce)

    assert encoded_signed_nonce ==
             "ZaAiVDgB5CeYoXoQ7cBCmq+ZllzUnGUoDVb8C7PilWvCs8XKfUchAUhz2P4BYAF++Dg3w05CqyQFRDiGL6LrDw=="
  end
end

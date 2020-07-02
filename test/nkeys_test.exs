defmodule NKEYSTest do
  use ExUnit.Case

  @seed "SUAMLK2ZNL35WSMW37E7UD4VZ7ELPKW7DHC3BWBSD2GCZ7IUQQXZIORRBU"

  test "from_seed" do
    nonce = "PXoWU7zWAMt75FY"
    {:ok, nkeys} = NKEYS.from_seed(@seed)
    signed_nonce = NKEYS.sign(nkeys, nonce)
    encoded_signed_nonce = Base.encode64(signed_nonce)

    assert encoded_signed_nonce ==
             "ZaAiVDgB5CeYoXoQ7cBCmq+ZllzUnGUoDVb8C7PilWvCs8XKfUchAUhz2P4BYAF++Dg3w05CqyQFRDiGL6LrDw=="
  end

  test "a second nonce" do
    nonce = "iBFByN3zQjAT7dQ"
    {:ok, nkeys} = NKEYS.from_seed(@seed)
    signed_nonce = NKEYS.sign(nkeys, nonce)
    encoded_signed_nonce = Base.url_encode64(signed_nonce)

    assert encoded_signed_nonce ==
             "kagPGrixaWS5yuHqw9nTQrda1Q376fK3fRCGtYdF4_w2aSk-4O7Ca0JM0qvzm69HH6MoMps2yF6Q0Qs830JZCA=="
  end

  test "creating a public nkey" do
    {:ok, nkeys} = NKEYS.from_seed(@seed)
    assert NKEYS.public_nkey(nkeys) == "UCK5N7N66OBOINFXAYC2ACJQYFSOD4VYNU6APEJTAVFZB2SVHLKGEW7L"
  end
end

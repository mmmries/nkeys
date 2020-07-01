defmodule NKEYS do
  alias NKEYS.Keypair

  def sign(%Keypair{public_key: public, private_key: private}, message) when is_binary(message) do
    Ed25519.signature("PXoWU7zWAMt75FY", private, public)
  end
end

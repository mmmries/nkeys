defmodule NKEYS.Keypair do
  defstruct [:seed, :public_key, :private_key]

  # TODO validate key
  def from_seed(seed) do
    with {:ok, binary} <- Base.decode32(seed, case: :mixed, padding: false) do
      raw_seed = :binary.part(binary, 2, byte_size(binary) - 4)
      {private, public} = Ed25519.generate_key_pair(raw_seed)

      keypair = %__MODULE__{
        seed: seed,
        public_key: public,
        private_key: private
      }

      {:ok, keypair}
    end
  end
end

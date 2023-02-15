defmodule NKEYS do
  defstruct [:seed, :public_key, :private_key]

  # PREFIX_BYTE_SEED is the version byte used for encoded NATS Seeds
  # Base32-encodes to 'S...'
  @prefix_seed 18

  # PREFIX_PRIVATE is the version byte used for encoded NATS Private keys
  # @prefix_private 15 # Base32-encodes to 'P...'

  # PREFIX_SERVER is the version byte used for encoded NATS Servers
  # Base32-encodes to 'N...'
  @prefix_server 13

  # PREFIX_CLUSTER is the version byte used for encoded NATS Clusters
  # Base32-encodes to 'C...'
  @prefix_cluster 2

  # PREFIX_OPERATOR is the version byte used for encoded NATS Operators
  # Base32-encodes to 'O...'
  @prefix_operator 14

  # PREFIX_ACCOUNT is the version byte used for encoded NATS Accounts
  # Base32-encodes to 'A...'
  @prefix_account 0

  # PREFIX_USER is the version byte used for encoded NATS Users
  # Base32-encodes to 'U...'
  @prefix_user 20

  @valid_nkey_types [
    @prefix_account,
    @prefix_cluster,
    @prefix_operator,
    @prefix_server,
    @prefix_user
  ]

  def from_seed(seed) when is_binary(seed) do
    with {:ok, binary} <- Base.decode32(seed, case: :mixed, padding: false),
         <<p1::size(5), p2::size(5), _::size(6), raw_seed::binary-size(32),
           _crc::size(16)-little>> <- binary,
         true <- valid_seed_prefix?(p1, p2) do
      {private, public} = Ed25519.generate_key_pair(raw_seed)

      keypair = %__MODULE__{
        seed: seed,
        public_key: public,
        private_key: private
      }

      {:ok, keypair}
    else
      _ ->
        {:error, :invalid_seed}
    end
  end

  def public_nkey(%__MODULE__{public_key: public_key}) do
    with_prefix = <<@prefix_user::size(5), 0::size(3), public_key::binary>>
    crc = NKEYS.CRC.compute(with_prefix)
    Base.encode32(<<with_prefix::binary, crc::size(16)-little>>, padding: false)
  end

  def sign(%__MODULE__{public_key: public, private_key: private}, message)
      when is_binary(message) do
    Ed25519.signature(message, private, public)
  end

  defp valid_seed_prefix?(prefix1, prefix2) do
    prefix1 == @prefix_seed &&
      prefix2 in @valid_nkey_types
  end
end

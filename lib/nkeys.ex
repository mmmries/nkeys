defmodule NKEYS do
  defstruct [:seed, :public_key, :private_key]

  # PREFIX_BYTE_SEED is the version byte used for encoded NATS Seeds
  @prefix_byte_seed 144 # Base32-encodes to 'S...'

  # PREFIX_BYTE_PRIVATE is the version byte used for encoded NATS Private keys
  @prefix_byte_private 120 # Base32-encodes to 'P...'

  # PREFIX_BYTE_SERVER is the version byte used for encoded NATS Servers
  @prefix_byte_server 104 # Base32-encodes to 'N...'

  # PREFIX_BYTE_CLUSTER is the version byte used for encoded NATS Clusters
  @prefix_byte_cluster 16 # Base32-encodes to 'C...'

  # PREFIX_BYTE_OPERATOR is the version byte used for encoded NATS Operators
  @prefix_byte_operator 112 # Base32-encodes to 'O...'

  # PREFIX_BYTE_ACCOUNT is the version byte used for encoded NATS Accounts
  @prefix_byte_account 0 # Base32-encodes to 'A...'

  # PREFIX_BYTE_USER is the version byte used for encoded NATS Users
  @prefix_byte_user 160 # Base32-encodes to 'U...'

  @valid_public_prefixes [
    @prefix_byte_operator,
    @prefix_byte_server,
    @prefix_byte_cluster,
    @prefix_byte_account,
    @prefix_byte_user
  ]

  # TODO validate key
  def from_seed(seed) do
    with {:ok, binary} <- Base.decode32(seed, case: :mixed, padding: false),
         <<_b1, _b2, raw_seed::size(32)-binary, _crc::size(16)-little>> <- binary do
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
    with_prefix = <<@prefix_byte_user, public_key::binary>>
    crc = NKEYS.CRC.compute(with_prefix)
    Base.encode32(<<@prefix_byte_user, public_key::binary, crc::size(16)-little>>, padding: false)
  end

  def sign(%__MODULE__{public_key: public, private_key: private}, message) when is_binary(message) do
    Ed25519.signature(message, private, public)
  end
end

defmodule NewChain.Address do
  @moduledoc """
  Documentation for `NewChain.Address`.
  """

  def hexAddress2NewAddress(hexAddress, chainId) when is_binary(hexAddress) and is_integer(chainId) do
    if(String.length(hexAddress) != 42 || String.starts_with?(hexAddress, "0x") == false) do
      hexAddress
    else
      {_prefix, address} = String.split_at(hexAddress, 2)
      case Base.decode16(address, case: :mixed) do
        {:ok, binaryAddress} ->
          hexChainId = Integer.to_string(chainId, 16)
          binaryChainId = case rem(String.length(hexChainId), 2) do
            0 -> Base.decode16!(hexChainId, case: :mixed)
            1 -> Base.decode16!("0" <> hexChainId, case: :mixed)
          end
          "NEW" <> B58.encode58_check!(binaryChainId <> binaryAddress, 0)
        :error ->
          hexAddress
      end
    end
  end

  def newAddress2HexAddress(newAddress) when is_binary(newAddress) do
    if(String.length(newAddress) < 38 || String.starts_with?(newAddress, "NEW") == false) do
      newAddress
    else
      {_prefix, data} = String.split_at(newAddress, 3)
      case B58.decode58_check(data) do
        {:ok, {chainIdAndBinaryAddress, _version}} ->
          <<_chainId :: bytes - size(2), binaryAddress :: bits>> = chainIdAndBinaryAddress
          "0x" <> Base.encode16(binaryAddress, case: :lower)
        {:error, _message} ->
          newAddress
      end
    end

  end

  def trimmedNewAddressEasy(address) do
    chainId = Application.fetch_env!(:block_scout_web, :chain_id)
    newAddress =
      address
      |> to_string
      |> hexAddress2NewAddress(chainId)
    "#{String.slice(newAddress, 0..6)}–#{String.slice(newAddress, -5..-1)}"
  end

  def fullNewAddressEasy(address) do
    chainId = Application.fetch_env!(:block_scout_web, :chain_id)
    address
    |> to_string
    |> hexAddress2NewAddress(chainId)
  end

end

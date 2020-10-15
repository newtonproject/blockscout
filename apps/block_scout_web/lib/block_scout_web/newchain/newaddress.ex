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
          binaryChainId =  case rem(String.length(hexChainId),2) do
            0 -> Base.decode16!(hexChainId, case: :mixed)
            1 -> Base.decode16!("0" <> hexChainId, case: :mixed)
          end
          "NEW" <> ExWallet.Base58.check_encode(Base.decode16!("00") <> binaryChainId <> binaryAddress)
        :error ->
          hexAddress
      end
    end
  end

  def trimmedNewAddressEasy(address, chainId \\ 1012) when is_integer(chainId) do
    newAddress =
      address
      |> to_string
      |> hexAddress2NewAddress(chainId)
    "#{String.slice(newAddress, 0..6)}–#{String.slice(newAddress, -5..-1)}"
  end

  def fullNewAddressEasy(address, chainId \\ 1012) when is_integer(chainId) do
    address
    |> to_string
    |> hexAddress2NewAddress(chainId)
  end

end

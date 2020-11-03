defmodule NewAsset do
  @moduledoc false

  def convertType(assetType) do
    case assetType do
      "ERC-20" -> "NRC-6"
      "ERC-721" -> "NRC-7"
      _ -> "NRC-???"
    end
  end

end
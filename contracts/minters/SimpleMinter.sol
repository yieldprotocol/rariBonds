// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@yield-protocol/utils-v2/contracts/token/ERC20.sol";
import "@uniswap/lib/contracts/libraries/TransferHelper.sol";
import "@yield-protocol/vault-interfaces/IFYToken.sol";

contract SmipleMinter {
  IFYToken public immutable fyToken;
  ERC20 public immutable saleToken;
  uint256 public immutable mintPrice;
  uint256 public immutable cap;
  address public immutable treasury;

  uint256 private immutable auctionTokenUnit;

  constructor(
    IFYToken _fyToken,
    ERC20 _saleToken,
    uint256 _mintPrice,
    uint256 _cap,
    address _treasury
  ) {
    fyToken = _fyToken;
    saleToken = _saleToken;
    mintPrice = _mintPrice;
    cap = _cap;
    treasury = _treasury;

    auctionTokenUnit = 10 ** ERC20(_saleToken).decimals();
  }

  function buyExactFYTokensWithTokens(
    uint256 _outFYTokens,
    address _recipient
  ) external {
    uint256 inTokens = _outFYTokens * mintPrice / auctionTokenUnit;
    require(fyToken.totalSupply() + inTokens <= cap, 'Exceeds cap');
    TransferHelper.safeTransferFrom(address(saleToken), msg.sender, treasury, inTokens);

    fyToken.mint(_recipient, _outFYTokens);
  }
}
